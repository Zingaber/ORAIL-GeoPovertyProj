# Define path to Rscript
$RScriptPath = $env:RScriptPath
if (-not (Test-Path $RScriptPath)) {
    Write-Host "❌ Rscript.exe not found at $RScriptPath. Ensure R is installed and this path is correct." -ForegroundColor Red
    exit 1
}

# Define required R packages
$RequiredPkgs = @(
    "rayshader", "terra", "elevatr", "sf", "magick", "rgl", "tidyverse", "reticulate"
)

# Create R code dynamically (NO BOM)
$RCode = @"
packages <- c(${((($RequiredPkgs | ForEach-Object { "`"`"$_`"`" }) -join ","))})
install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE, repos = 'https://cloud.r-project.org')
  }
}
for (pkg in packages) {
  install_if_missing(pkg)
}
cat('✅ All required R packages processed.
')
"@

# Save R code to temp file WITHOUT BOM
$TempRScript = [System.IO.Path]::GetTempFileName() + ".R"
[System.IO.File]::WriteAllText($TempRScript, $RCode, [System.Text.Encoding]::UTF8NoBOM)

# Log file
$LogFile = "$env:TEMP\r_package_install_log.txt"

# Run Rscript
& "$RScriptPath" "$TempRScript" *> "$LogFile"

Write-Host "✅ Script executed. Log saved to: $LogFile"
