# PowerShell Script to Check and Install Required R Packages for ORAIL
# Updated for conda environment and correct project paths
# Usage: Run in PowerShell from project root directory

# Set the correct RScript path for orail_env conda environment
$env:RScriptPath = "C:\Users\josze\anaconda3\User-quantuM-CDAC-CLASS\anaconda3\envs\orail_env\Scripts\Rscript.exe"

# Verify RScript exists
if (!(Test-Path $env:RScriptPath)) {
  Write-Error "ERROR: Rscript.exe not found at $env:RScriptPath"
  Write-Host "INFO: Make sure conda environment 'orail_env' is created and R is installed"
  exit 1
}

Write-Host "SUCCESS: Found Rscript at: $env:RScriptPath"

# Ensure UTF-8 encoding without BOM for embedded R code
$RScriptContent = @"
# ORAIL R Package Check and Installation Script
cat("ORAIL R Package Verification Starting...\n")
cat("============================================\n")

# Required packages for ORAIL GeoPoverty Mapping
packages <- c(
  "rayshader",    # 3D terrain visualization
  "terra",        # spatial data analysis
  "elevatr",      # elevation data
  "sf",          # spatial features
  "magick",      # image processing
  "rgl",         # 3D graphics
  "tidyverse",   # data manipulation
  "reticulate",  # R-Python integration
  "tmap",        # thematic mapping
  "leaflet",     # interactive maps
  "raster",      # raster processing
  "sp",          # spatial classes
  "rgdal",       # geospatial data abstraction
  "RColorBrewer", # color palettes
  "viridis"      # color scales
)

# Function to install missing packages
install_if_missing <- function(pkg) {
  cat(sprintf("Checking package: %s... ", pkg))
  
  if (requireNamespace(pkg, quietly = TRUE)) {
    cat("INSTALLED\n")
    return(TRUE)
  } else {
    cat("MISSING, installing...\n")
    tryCatch({
      install.packages(pkg, dependencies = TRUE, repos = "https://cloud.r-project.org")
      cat(sprintf("SUCCESS: Installed %s\n", pkg))
      return(TRUE)
    }, error = function(e) {
      cat(sprintf("ERROR: Failed to install %s: %s\n", pkg, e\$message))
      return(FALSE)
    })
  }
}

# Check and install all packages
cat("\nChecking required packages:\n")
results <- sapply(packages, install_if_missing)

# Summary
installed_count <- sum(results)
total_count <- length(packages)

cat("\n============================================\n")
cat("INSTALLATION SUMMARY:\n")
cat(sprintf("Installed: %d/%d packages\n", installed_count, total_count))

if (installed_count == total_count) {
  cat("SUCCESS: All packages ready for ORAIL poverty mapping!\n")
} else {
  failed_packages <- names(results)[!results]
  cat("WARNING: Failed packages:\n")
  for (pkg in failed_packages) {
    cat(sprintf("   - %s\n", pkg))
  }
}

# System information
cat("\nR ENVIRONMENT INFO:\n")
cat(sprintf("R Version: %s\n", R.version.string))
cat(sprintf("Platform: %s\n", R.version\$platform))

# Library paths
cat("\nLibrary paths:\n")
lib_paths <- .libPaths()
for (i in seq_along(lib_paths)) {
  cat(sprintf("  %d. %s\n", i, lib_paths[i]))
}

# Test key packages
cat("\nFUNCTIONALITY TESTS:\n")

# Test rayshader
tryCatch({
  library(rayshader, quietly = TRUE)
  test_matrix <- matrix(rnorm(100), nrow = 10)
  height_shade(test_matrix)
  cat("SUCCESS: rayshader 3D rendering functional\n")
}, error = function(e) {
  cat("ERROR: rayshader test failed\n")
})

# Test sf
tryCatch({
  library(sf, quietly = TRUE)
  pt <- st_point(c(0, 0))
  cat("SUCCESS: sf spatial features functional\n")
}, error = function(e) {
  cat("ERROR: sf test failed\n")
})

# Test reticulate (Python integration)
tryCatch({
  library(reticulate, quietly = TRUE)
  py_available <- py_available()
  cat(sprintf("INFO: reticulate Python integration %s\n", 
             ifelse(py_available, "available", "not available")))
}, error = function(e) {
  cat("ERROR: reticulate test failed\n")
})

cat("\nORAIL R environment verification complete!\n")
"@

# Save R script temporarily
$TempRScript = "$env:TEMP\orail_r_package_check.R"
[System.IO.File]::WriteAllText($TempRScript, $RScriptContent, [System.Text.UTF8Encoding]::new($false))

# Output log path (corrected for your project)
$LogFile = "C:\Users\josze\MYRworkspace-CitizenAI-poverty-mapping\logs\r_package_install_log.txt"

# Ensure log directory exists
$LogDir = [System.IO.Path]::GetDirectoryName($LogFile)
if (!(Test-Path $LogDir)) {
  New-Item -Path $LogDir -ItemType Directory -Force | Out-Null
  Write-Host "CREATED: logs directory at $LogDir"
}

Write-Host "STARTING: R package verification for ORAIL..."
Write-Host "USING: R from $env:RScriptPath"
Write-Host "LOG: Will be saved to $LogFile"
Write-Host ""

# Run the Rscript and capture output
try {
  & "$env:RScriptPath" "$TempRScript" 2>&1 | Tee-Object -FilePath $LogFile
  Write-Host "`nSUCCESS: R package check completed!"
  Write-Host "LOG: Full log saved to $LogFile"
    
  # Clean up temp file
  Remove-Item $TempRScript -ErrorAction SilentlyContinue
    
}
catch {
  Write-Error "ERROR: Failed to run R script: $_"
  Write-Host "TIP: Try running 'conda activate orail_env' first"
}

Write-Host "`nNEXT: Review results and proceed with ORAIL MVP development"