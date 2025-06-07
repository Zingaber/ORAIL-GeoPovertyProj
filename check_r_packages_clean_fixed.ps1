# check_r_packages_clean_fixed.ps1

# Define required R packages
$RequiredPkgs = @("rayshader", "terra", "elevatr", "sf", "magick", "rgl", "tidyverse", "reticulate")

# Locate Rscript.exe
$RScriptPath = Get-Command Rscript -ErrorAction SilentlyContinue
if (-not $RScriptPath) {
    Write-Host "❌ Rscript.exe not found. Ensure R is installed and Rscript is in your PATH." -ForegroundColor Red
    exit 1
}
$RScriptPath = $RScriptPath.Path

# Create a temporary R script
$TempRScript = "$env:TEMP\check_r_pkgs.R"
$LogFile = "$env:TEMP\r_pkg_check_log.txt"

# Write R code into temp file
@"
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
"@ | Out-File -Encoding UTF8 -FilePath $TempRScript

# Run the R script
Write-Host "🚀 Running R package check..."
& $RScriptPath $TempRScript *> $LogFile

# Output summary
Write-Host "`n📄 Log saved to: $LogFile"
Get-Content $LogFile
