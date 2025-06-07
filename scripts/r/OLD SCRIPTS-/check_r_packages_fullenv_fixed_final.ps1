# Set RScript path if not already defined
if (-not $env:RScriptPath) {
    $env:RScriptPath = "C:\Program Files\R\R-4.5.0\bin\Rscript.exe"
}

# Define required R packages
$RequiredPkgs = @("rayshader", "terra", "elevatr", "sf", "magick", "rgl", "tidyverse", "reticulate")

# Set paths
$TempRScript = "$env:TEMP\check_r_packages_temp_script.R"
$LogFile = "C:\Users\josze\MyRWorkspace\r_package_install_log.txt"

# Prepare R script content
$RScriptContent = @"
packages <- c("rayshader", "terra", "elevatr", "sf", "magick", "rgl", "tidyverse", "reticulate")

install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE, repos = "https://cloud.r-project.org")
  }
}

for (pkg in packages) {
  install_if_missing(pkg)
}

cat("✅ All required R packages installed.\n")

# Log loaded libraries with root path and version
cat("----- PACKAGE PATHS AND INFO -----\n")
for (pkg in packages) {
  if (require(pkg, character.only = TRUE)) {
    cat("✔", pkg, "loaded from:", find.package(pkg), "\n")
    cat("Version:", as.character(packageVersion(pkg)), "\n")
  }
}
"@

# Save R script to temp location (UTF-8 w/o BOM)
Set-Content -Path $TempRScript -Value $RScriptContent -Encoding UTF8

# Run the R script and redirect output to log file AND screen
Write-Output "Running R script to install and verify packages..."
& "$env:RScriptPath" "$TempRScript" *>> "$LogFile"
Get-Content -Path $LogFile

Write-Output "Log also saved to: $LogFile"