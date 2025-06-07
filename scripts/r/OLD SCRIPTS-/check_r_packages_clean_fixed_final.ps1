# PowerShell Script: check_r_packages_clean_fixed_final.ps1
# Purpose: Ensure R and Rscript exist, then check and install R packages

# CONFIG
$RScriptPath = $env:RScriptPath
$LogFile = "$env:TEMP\r_package_install_log.txt"
$TempRScript = "$env:TEMP\check_packages_temp_script.R"

# Validate Rscript exists
if (-Not (Test-Path $RScriptPath)) {
    Write-Error "❌ Rscript.exe not found. Ensure R is installed and Rscript is in your PATH."
    exit 1
}

# List of R packages to check
$RequiredPkgs = @("rayshader", "terra", "elevatr", "sf", "magick", "rgl", "tidyverse", "reticulate")

# Create the R code block
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

cat("✅ All required R packages checked or installed.\n")
"@

# Write R script to temp file
$RScriptContent | Out-File -Encoding UTF8 -FilePath $TempRScript -Force

# Run Rscript and capture output
& "$RScriptPath" "$TempRScript" *>$LogFile

# Show log summary
Get-Content $LogFile
