
$RScriptPath = "C:\Program Files\R\R-4.5.0\bin\Rscript.exe"
$TempRFile = "$env:TEMP\check_r_packages.R"

if (-Not (Test-Path $RScriptPath)) {
    Write-Host "❌ Rscript not found at $RScriptPath. Please verify R installation path." -ForegroundColor Red
    exit 1
}

$RCode = @"
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

$RCode | Out-File -Encoding UTF8 -FilePath $TempRFile
& $RScriptPath $TempRFile | Tee-Object -FilePath "check_r_packages_log.txt"
notepad.exe "check_r_packages_log.txt"
