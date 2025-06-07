# Set your Rscript path if not already in PATH
if (-not $env:RScriptPath) {
    $env:RScriptPath = "C:\Program Files\R\R-4.5.0\bin\Rscript.exe"
}

# Create a temp R script to check and install required packages
$TempRScript = "$env:TEMP\check_r_packages.R"
$LogFile = "$env:TEMP\r_package_install_log.txt"

# Define the required packages in R syntax
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

cat("✅ All required R packages are installed.\n")
"@

# Write the content to the R script file
Set-Content -Path $TempRScript -Value $RScriptContent -Encoding ASCII

# Execute the R script using Rscript
& "$env:RScriptPath" "$TempRScript" *> $LogFile

# Output result location
Write-Output "`n📄 R package installation log saved to: $LogFile`n"