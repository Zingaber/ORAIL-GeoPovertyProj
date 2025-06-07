# Set paths
$LogFile = "C:\Users\josze\MyRWorkspace\r_package_install_log.txt"
$TempRScript = "$env:TEMP\check_packages_script.R"

# Define R package check-and-load code as raw text
$RCode = @"
packages <- c("rayshader", "terra", "elevatr", "sf", "magick", "rgl", "tidyverse", "reticulate")

install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    cat(sprintf("Installing missing package: %s\n", pkg))
    install.packages(pkg, dependencies = TRUE, repos = "https://cloud.r-project.org")
  }
}

for (pkg in packages) {
  install_if_missing(pkg)
}

cat("📦 Package Paths:\n")
for (pkg in packages) {
  libpath <- tryCatch(find.package(pkg), error = function(e) NA)
  if (!is.na(libpath)) {
    cat(sprintf(" - %s: %s\n", pkg, libpath))
  } else {
    cat(sprintf(" - %s: NOT FOUND\n", pkg))
  }
}

cat("✅ All required R packages checked and loaded.\n")
"@

# Save without BOM
Set-Content -Path $TempRScript -Value $RCode -Encoding UTF8

# Ensure Rscript path is set
if (-not $env:RScriptPath) {
  $env:RScriptPath = "C:\Program Files\R\R-4.5.0\bin\Rscript.exe"
}

# Confirm Rscript exists
if (!(Test-Path $env:RScriptPath)) {
  Write-Error "❌ Rscript.exe not found at $env:RScriptPath. Please check your path."
  exit 1
}

# Run the R script and tee output to console and file
& "$env:RScriptPath" "$TempRScript" 2>&1 | Tee-Object -FilePath $LogFile

# Final notice
Write-Host "📄 Log saved to: $LogFile"
