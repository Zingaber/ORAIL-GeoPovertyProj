# PowerShell Script: check_r_packages_fullenv.ps1
# Description: Checks and installs R packages and logs all relevant R library and installation paths.

# Set the Rscript path explicitly
$env:RScriptPath = "C:\Program Files\R\R-4.5.0\bin\Rscript.exe"

# Path to save log file
$LogFile = "C:\Users\josze\MyRWorkspace\r_package_install_log.txt"

# Create temporary R script
$TempRScript = "$env:TEMP\r_package_check_20250607_094911.R"

# Write R code to the temporary R script
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

cat("✔ All required R packages installed.\n\n")
cat("🔍 R Library Paths (R_LIBS):\n")
cat(.libPaths(), sep = "\n")
cat("\n\n📁 Installed Package Locations:\n")
for (pkg in packages) {
  cat(pkg, ": ", find.package(pkg, quiet = TRUE), "\n", sep="")
}

cat("\n🔗 Linked System Libraries:\n")
cat(paste("GDAL:", sf::sf_extSoftVersion()[["GDAL"]]), "\n")
cat(paste("GEOS:", sf::sf_extSoftVersion()[["GEOS"]]), "\n")
cat(paste("PROJ:", sf::sf_extSoftVersion()[["PROJ"]]), "\n")
cat(paste("ImageMagick:", magick::magick_config()$version), "\n")
cat(paste("Magick Enabled Features:", paste(magick::magick_config()$features, collapse=", ")), "\n")
"@ | Set-Content -Path $TempRScript -Encoding UTF8

# Run the R script and capture the output
& "$env:RScriptPath" "$TempRScript" *>> "$LogFile"

# Display output in the shell as well
Get-Content -Path "$LogFile"
