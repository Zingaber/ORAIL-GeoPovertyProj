# ORAIL Package Verification Script
# Comprehensive check of your package installation status
# Created: 2025-06-09

cat("=== ORAIL Package Verification Script ===\n")
cat("Checking your current package installation status...\n\n")

# Set working directory
setwd("C:/Users/josze/MYRworkspace-CitizenAI-poverty-mapping")

cat("Working directory:", getwd(), "\n")
cat("R version:", R.version.string, "\n\n")

# Your listed packages with versions
your_packages <- data.frame(
  package = c("getern", "lubridate", "dplyr", "tidyr", "purrr", "forcats", 
              "tibble", "stringr", "readr", "ggplot2", "tidyverse", "terra", 
              "elevatr", "sf", "ggspatial", "rgeoboundaries", "rstack"),
  expected_version = c("3.5.0", "1.9.3", "1.1.4", "1.3.1", "1.0.2", "1.0.0",
                      "3.2.1", "1.5.1", "2.1.4", "3.5.1", "2.0.0", "1.7-80",
                      "0.99.0", "1.0-16", "1.1.9", "1.2.9000", "1.0.0"),
  category = c("Custom", "DateTime", "DataManip", "DataManip", "Functional", "Categorical",
               "DataStructure", "String", "IO", "Plotting", "Meta", "Geospatial",
               "Elevation", "SpatialVector", "Plotting", "Boundaries", "RasterStack"),
  importance = c("Medium", "Medium", "High", "High", "Medium", "Low",
                 "High", "Medium", "Medium", "High", "High", "Critical",
                 "Critical", "Critical", "Medium", "High", "Medium"),
  stringsAsFactors = FALSE
)

cat("=== 1. CHECKING CURRENTLY LOADED PACKAGES ===\n")

# Check what's currently loaded
loaded_namespaces <- loadedNamespaces()
attached_packages <- search()

cat("Currently loaded namespaces:", length(loaded_namespaces), "\n")
cat("Currently attached packages:", length(attached_packages), "\n\n")

# Check your specific packages
cat("Your Package Status:\n")
cat(sprintf("%-20s %-12s %-15s %-10s %s\n", "Package", "Status", "Your Version", "Expected", "Category"))
cat(paste(rep("-", 80), collapse = ""), "\n")

package_status <- data.frame(
  package = character(0),
  status = character(0),
  installed_version = character(0),
  expected_version = character(0),
  loaded = logical(0),
  stringsAsFactors = FALSE
)

for(i in 1:nrow(your_packages)) {
  pkg <- your_packages$package[i]
  expected_ver <- your_packages$expected_version[i]
  category <- your_packages$category[i]
  
  # Check if installed
  if(requireNamespace(pkg, quietly = TRUE)) {
    # Get installed version
    installed_ver <- tryCatch({
      as.character(packageVersion(pkg))
    }, error = function(e) "Unknown")
    
    # Check if loaded
    is_loaded <- pkg %in% loaded_namespaces
    
    status <- if(is_loaded) "LOADED" else "INSTALLED"
    
    cat(sprintf("%-20s %-12s %-15s %-10s %s\n", 
                pkg, status, installed_ver, expected_ver, category))
    
    package_status <- rbind(package_status, data.frame(
      package = pkg,
      status = status,
      installed_version = installed_ver,
      expected_version = expected_ver,
      loaded = is_loaded,
      stringsAsFactors = FALSE
    ))
    
  } else {
    cat(sprintf("%-20s %-12s %-15s %-10s %s\n", 
                pkg, "NOT FOUND", "N/A", expected_ver, category))
    
    package_status <- rbind(package_status, data.frame(
      package = pkg,
      status = "NOT FOUND",
      installed_version = "N/A",
      expected_version = expected_ver,
      loaded = FALSE,
      stringsAsFactors = FALSE
    ))
  }
}

cat("\n=== 2. PACKAGE STATUS SUMMARY ===\n")

status_summary <- table(package_status$status)
cat("Package Status Distribution:\n")
for(status in names(status_summary)) {
  cat(sprintf("  %s: %d packages\n", status, status_summary[status]))
}

# Check critical packages
critical_packages <- your_packages[your_packages$importance == "Critical", "package"]
critical_status <- package_status[package_status$package %in% critical_packages, ]

cat("\nCritical Package Status:\n")
for(i in 1:nrow(critical_status)) {
  pkg_info <- critical_status[i, ]
  status_indicator <- if(pkg_info$status == "LOADED") "OK" else 
                     if(pkg_info$status == "INSTALLED") "WARNING" else "ERROR"
  cat(sprintf("  %s %s - %s\n", status_indicator, pkg_info$package, pkg_info$status))
}

cat("\n=== 3. ADDITIONAL PACKAGES NEEDED FOR ORAIL ===\n")

# Additional packages needed for 3D mapping and satellite analysis
additional_packages <- c("rayshader", "viridis", "plotly", "RColorBrewer", "scales", 
                         "jsonlite", "gridExtra", "cowplot")

cat("Checking additional packages needed for ORAIL framework:\n")
cat(sprintf("%-20s %-12s %-15s\n", "Package", "Status", "Version"))
cat(paste(rep("-", 50), collapse = ""), "\n")

additional_status <- data.frame(
  package = character(0),
  status = character(0),
  version = character(0),
  stringsAsFactors = FALSE
)

for(pkg in additional_packages) {
  if(requireNamespace(pkg, quietly = TRUE)) {
    version <- tryCatch({
      as.character(packageVersion(pkg))
    }, error = function(e) "Unknown")
    
    is_loaded <- pkg %in% loaded_namespaces
    status <- if(is_loaded) "LOADED" else "INSTALLED"
    
    cat(sprintf("%-20s %-12s %-15s\n", pkg, status, version))
    
    additional_status <- rbind(additional_status, data.frame(
      package = pkg,
      status = status,
      version = version,
      stringsAsFactors = FALSE
    ))
    
  } else {
    cat(sprintf("%-20s %-12s %-15s\n", pkg, "NOT FOUND", "N/A"))
    
    additional_status <- rbind(additional_status, data.frame(
      package = pkg,
      status = "NOT FOUND",
      version = "N/A",
      stringsAsFactors = FALSE
    ))
  }
}

cat("\n=== 4. TESTING KEY PACKAGE FUNCTIONALITY ===\n")

# Test key packages to ensure they work
test_results <- list()

# Test terra (critical for raster processing)
cat("Testing terra package functionality...\n")
test_results$terra <- tryCatch({
  library(terra, quietly = TRUE)
  # Create a simple raster
  test_rast <- rast(nrows = 10, ncols = 10)
  values(test_rast) <- 1:100
  result <- "SUCCESS - terra working correctly"
  cat("  SUCCESS: terra package functional\n")
  result
}, error = function(e) {
  result <- paste("ERROR:", e$message)
  cat("  ERROR: terra package issue -", e$message, "\n")
  result
})

# Test sf (critical for vector processing)
cat("Testing sf package functionality...\n")
test_results$sf <- tryCatch({
  library(sf, quietly = TRUE)
  # Create a simple point
  test_point <- st_point(c(75, 10))
  test_sf <- st_sfc(test_point, crs = 4326)
  result <- "SUCCESS - sf working correctly"
  cat("  SUCCESS: sf package functional\n")
  result
}, error = function(e) {
  result <- paste("ERROR:", e$message)
  cat("  ERROR: sf package issue -", e$message, "\n")
  result
})

# Test elevatr (critical for elevation data)
cat("Testing elevatr package functionality...\n")
test_results$elevatr <- tryCatch({
  library(elevatr, quietly = TRUE)
  # Simple check - don't actually download data
  result <- "SUCCESS - elevatr loaded correctly"
  cat("  SUCCESS: elevatr package loaded\n")
  result
}, error = function(e) {
  result <- paste("ERROR:", e$message)
  cat("  ERROR: elevatr package issue -", e$message, "\n")
  result
})

# Test ggplot2 (critical for visualization)
cat("Testing ggplot2 package functionality...\n")
test_results$ggplot2 <- tryCatch({
  library(ggplot2, quietly = TRUE)
  # Create a simple plot
  test_plot <- ggplot(data.frame(x = 1:5, y = 1:5), aes(x, y)) + geom_point()
  result <- "SUCCESS - ggplot2 working correctly"
  cat("  SUCCESS: ggplot2 package functional\n")
  result
}, error = function(e) {
  result <- paste("ERROR:", e$message)
  cat("  ERROR: ggplot2 package issue -", e$message, "\n")
  result
})

# Test dplyr (critical for data manipulation)
cat("Testing dplyr package functionality...\n")
test_results$dplyr <- tryCatch({
  library(dplyr, quietly = TRUE)
  # Simple data manipulation test
  test_data <- data.frame(x = 1:5, y = letters[1:5])
  result_data <- test_data %>% filter(x > 2) %>% mutate(z = x * 2)
  result <- "SUCCESS - dplyr working correctly"
  cat("  SUCCESS: dplyr package functional\n")
  result
}, error = function(e) {
  result <- paste("ERROR:", e$message)
  cat("  ERROR: dplyr package issue -", e$message, "\n")
  result
})

cat("\n=== 5. SYSTEM INFORMATION ===\n")

# Get system info
cat("R Session Information:\n")
cat("R version:", R.version.string, "\n")
cat("Platform:", R.version$platform, "\n")
cat("Operating System:", Sys.info()["sysname"], Sys.info()["release"], "\n")
cat("User:", Sys.info()["user"], "\n")
cat("Working Directory:", getwd(), "\n")

# Check if we're in RStudio
if(Sys.getenv("RSTUDIO") == "1") {
  cat("Environment: RStudio\n")
} else {
  cat("Environment: Base R\n")
}

cat("\n=== 6. ORAIL READINESS ASSESSMENT ===\n")

# Calculate readiness score
total_packages <- nrow(your_packages) + length(additional_packages)
loaded_count <- sum(package_status$loaded) + sum(additional_status$status == "LOADED")
installed_count <- sum(package_status$status %in% c("LOADED", "INSTALLED")) + 
                  sum(additional_status$status %in% c("LOADED", "INSTALLED"))

# Critical packages check
critical_ready <- all(critical_status$status %in% c("LOADED", "INSTALLED"))

readiness_score <- (installed_count / total_packages) * 100

cat("ORAIL Framework Readiness Assessment:\n")
cat(sprintf("  Total packages checked: %d\n", total_packages))
cat(sprintf("  Packages installed: %d\n", installed_count))
cat(sprintf("  Packages loaded: %d\n", loaded_count))
cat(sprintf("  Readiness score: %.1f%%\n", readiness_score))

if(critical_ready && readiness_score >= 80) {
  assessment <- "READY"
  cat("  Assessment: READY - Proceed with ORAIL framework\n")
} else if(readiness_score >= 60) {
  assessment <- "PARTIAL"
  cat("  Assessment: PARTIAL - Some packages missing, but workable\n")
} else {
  assessment <- "NOT READY"
  cat("  Assessment: NOT READY - Significant packages missing\n")
}

cat("\n=== 7. RECOMMENDED ACTIONS ===\n")

# Missing packages
missing_packages <- c(
  package_status[package_status$status == "NOT FOUND", "package"],
  additional_status[additional_status$status == "NOT FOUND", "package"]
)

if(length(missing_packages) > 0) {
  cat("Missing packages that need installation:\n")
  for(pkg in missing_packages) {
    cat(sprintf("  install.packages('%s')\n", pkg))
  }
  
  cat("\nBatch installation command:\n")
  cat("install.packages(c(", paste(sprintf("'%s'", missing_packages), collapse = ", "), "))\n")
}

# Packages installed but not loaded
not_loaded <- package_status[package_status$status == "INSTALLED", "package"]
if(length(not_loaded) > 0) {
  cat("\nPackages installed but not loaded (will be loaded automatically):\n")
  for(pkg in not_loaded) {
    cat(sprintf("  %s\n", pkg))
  }
}

cat("\n=== VERIFICATION COMPLETE ===\n")
cat("Assessment:", assessment, "\n")

if(assessment == "READY") {
  cat("You can proceed with the ORAIL framework immediately.\n")
} else if(assessment == "PARTIAL") {
  cat("Install missing packages, then proceed with ORAIL framework.\n")
} else {
  cat("Install missing packages before proceeding.\n")
}

# Save verification results
verification_results <- list(
  verification_date = Sys.time(),
  r_version = R.version.string,
  platform = R.version$platform,
  working_directory = getwd(),
  package_status = package_status,
  additional_status = additional_status,
  test_results = test_results,
  readiness_score = readiness_score,
  assessment = assessment,
  missing_packages = missing_packages,
  recommendations = if(length(missing_packages) > 0) {
    paste("Install missing packages:", paste(missing_packages, collapse = ", "))
  } else {
    "All packages ready - proceed with ORAIL framework"
  }
)

# Create outputs directory if it doesn't exist
if(!dir.exists("outputs")) {
  dir.create("outputs", recursive = TRUE)
}

# Save results
if(requireNamespace("jsonlite", quietly = TRUE)) {
  jsonlite::write_json(verification_results, "outputs/package_verification.json", pretty = TRUE)
  cat("Verification results saved to: outputs/package_verification.json\n")
} else {
  # Save as R object if jsonlite not available
  save(verification_results, file = "outputs/package_verification.RData")
  cat("Verification results saved to: outputs/package_verification.RData\n")
}

cat("\nRun this script first, then proceed with ORAIL framework based on the assessment.\n")
