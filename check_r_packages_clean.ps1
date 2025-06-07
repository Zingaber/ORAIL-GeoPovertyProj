# check_r_packages_clean.ps1
# ------------------------------------------------------------
# Purpose : Verify R installation and ensure required packages
#           are installed (without triggering BOM issues)
# Author  : ChatGPT assistant
# ------------------------------------------------------------

Param()

# ---- 1. Locate Rscript ---------------------------------------------------
$DefaultR = "C:\Program Files\R"
$RScriptPath = Get-ChildItem -Path $DefaultR -Recurse -Filter Rscript.exe -ErrorAction SilentlyContinue |
               Sort-Object FullName -Descending | Select-Object -First 1 -ExpandProperty FullName

if (-not $RScriptPath) {
    Write-Host "❌ Rscript.exe not found under $DefaultR. Please install R first." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Found Rscript at $RScriptPath" -ForegroundColor Green

# ---- 2. Build the R helper script ---------------------------------------
$RequiredPkgs = @(
  'rayshader','terra','elevatr','sf','magick','rgl','tidyverse','reticulate'
)

$RCode = @"
packages <- c(${( $RequiredPkgs | ForEach-Object { '"' + $_ + '"' } ) -join ', '})

install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE, repos = 'https://cloud.r-project.org')
  }
}

for (pkg in packages) {
  install_if_missing(pkg)
}

cat('✅ All required R packages installed.\n')
"@

# Write without BOM
$TempR = Join-Path $env:TEMP 'check_r_packages.R'
[System.IO.File]::WriteAllText($TempR, $RCode, (New-Object System.Text.UTF8Encoding $false))

# ---- 3. Run R and capture output ----------------------------------------
$LogFile = Join-Path $env:TEMP 'check_r_packages_log.txt'
& $RScriptPath $TempR *>&1 | Tee-Object -FilePath $LogFile

Write-Host "ℹ️  Detailed log saved to $LogFile" -ForegroundColor Yellow
"#
