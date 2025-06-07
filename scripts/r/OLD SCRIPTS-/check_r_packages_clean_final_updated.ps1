
# PowerShell Script: check_r_packages_clean_final_updated.ps1
# Purpose: Check and install required R packages using Rscript.exe, output logs to file and console

# Define Rscript path (adjust if needed)
$RScriptPath = "C:\Program Files\R\R-4.5.0\bin\Rscript.exe"

# Check if Rscript exists
if (!(Test-Path $RScriptPath)) {
    Write-Host "❌ Rscript.exe not found. Please ensure R is installed and Rscript is in the correct path."
    exit 1
}

# Define log file path
$LogFile = "C:\Users\josze\MyRWorkspace\r_package_install_log.txt"

# Define required R packages
$RequiredPkgs = @("rayshader", "terra", "elevatr", "sf", "magick", "rgl", "tidyverse", "reticulate")

# Generate temporary R script
$TempRScript = [System.IO.Path]::GetTempFileName() + ".R"

# Write R script content to temp file
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
"@

[System.IO.File]::WriteAllText($TempRScript, $RScriptContent)

# Execute R script and save output
& "$RScriptPath" "$TempRScript" *>$LogFile

# Display log contents to console
Write-Host "`n=== R Package Installation Log ===`n"
Get-Content $LogFile

# Clean up
Remove-Item $TempRScript -Force
