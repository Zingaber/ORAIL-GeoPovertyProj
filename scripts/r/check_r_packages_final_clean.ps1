
# PowerShell Script to Check and Install Required R Packages
# Save this file as check_r_packages_final_clean.ps1
# Usage: Run in PowerShell after setting RScriptPath

# Ensure UTF-8 encoding without BOM for embedded R code
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

# Output installation paths
cat("\n🔍 Library paths:\n")
print(.libPaths())

cat("\n🔍 Installed packages and versions:\n")
print(installed.packages()[, c("Package", "Version", "LibPath")])

"@

# Save R script temporarily
$TempRScript = "$env:TEMP\r_package_check_script.R"
[System.IO.File]::WriteAllText($TempRScript, $RScriptContent, [System.Text.UTF8Encoding]::new($false))

# Output log path
$LogFile = "C:\Users\josze\MyRWorkspace\r_package_install_log.txt"

# Ensure log directory exists
$LogDir = [System.IO.Path]::GetDirectoryName($LogFile)
if (!(Test-Path $LogDir)) {
    New-Item -Path $LogDir -ItemType Directory | Out-Null
}

# Run the Rscript and capture output
if (Test-Path "$env:RScriptPath") {
    & "$env:RScriptPath" "$TempRScript" 2>&1 | Tee-Object -FilePath $LogFile
    Write-Host "`n📄 Log saved to: $LogFile"
} else {
    Write-Error "❌ Rscript.exe not found at $env:RScriptPath. Please verify your R installation path."
}
