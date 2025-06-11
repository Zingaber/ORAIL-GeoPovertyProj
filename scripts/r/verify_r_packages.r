# =============================================================================
# ORAIL GeoPoverty Mapping - R Package Verification Script
# Enhanced validation for 3D mapping, geospatial analysis, and poverty mapping
# =============================================================================

cat("ORAIL R Package Verification Starting...\n")
cat(paste(rep("=", 60), collapse = ""), "\n")

# Core packages for ORAIL GeoPoverty Mapping
required_packages <- list(
  # 3D Visualization & Mapping
  "3d_viz" = c("rayshader", "rgl", "magick", "av"),
  
  # Geospatial Core
  "geospatial" = c("sf", "terra", "raster", "sp", "rgdal"),
  
  # Elevation & Terrain
  "elevation" = c("elevatr", "rnaturalearth", "rnaturalearthdata"),
  
  # Mapping & Visualization  
  "mapping" = c("tmap", "leaflet", "ggplot2", "RColorBrewer", "viridis"),
  
  # Data Processing
  "data_proc" = c("dplyr", "tidyr", "readr", "jsonlite"),
  
  # Statistical Analysis
  "stats" = c("corrplot", "cluster", "factoextra"),
  
  # R-Python Integration (for LLM)
  "integration" = c("reticulate", "rmarkdown", "knitr")
)

# Function to check and test package functionality
check_package <- function(pkg_name) {
  tryCatch({
    # Check if installed
    if (!requireNamespace(pkg_name, quietly = TRUE)) {
      return(list(status = "NOT_INSTALLED", msg = "Not Installed", test = FALSE))
    }
    
    # Try to load
    suppressMessages(suppressWarnings(
      library(pkg_name, character.only = TRUE, quietly = TRUE)
    ))
    
    # Basic functionality tests
    test_result <- switch(pkg_name,
      "rayshader" = {
        # Test basic rayshader functionality
        test_matrix <- matrix(rnorm(100), nrow = 10)
        tryCatch({
          height_shade(test_matrix)
          TRUE
        }, error = function(e) FALSE)
      },
      "sf" = {
        # Test sf functionality
        tryCatch({
          pt <- st_point(c(0, 0))
          TRUE
        }, error = function(e) FALSE)
      },
      "terra" = {
        # Test terra functionality
        tryCatch({
          r <- rast(nrows = 10, ncols = 10)
          TRUE
        }, error = function(e) FALSE)
      },
      "reticulate" = {
        # Test Python connectivity
        tryCatch({
          py_available()
        }, error = function(e) FALSE)
      },
      TRUE  # Default: assume working if loaded
    )
    
    status <- if (test_result) "WORKING" else "WARNING"
    msg <- if (test_result) "Working" else "Loaded but failed test"
    
    return(list(status = status, msg = msg, test = test_result))
    
  }, error = function(e) {
    return(list(status = "ERROR", msg = paste("Error:", e$message), test = FALSE))
  })
}

# Function to suggest installation command
get_install_cmd <- function(pkg_name) {
  special_installs <- list(
    "rgdal" = 'install.packages("rgdal", type = "binary")',
    "sf" = 'install.packages("sf", type = "binary")',
    "terra" = 'install.packages("terra", type = "binary")',
    "rayshader" = 'install.packages("rayshader", dependencies = TRUE)'
  )
  
  if (pkg_name %in% names(special_installs)) {
    return(special_installs[[pkg_name]])
  } else {
    return(paste0('install.packages("', pkg_name, '")'))
  }
}

# Function to format status symbol
get_status_symbol <- function(status) {
  switch(status,
    "WORKING" = "[OK]",
    "WARNING" = "[WARN]",
    "NOT_INSTALLED" = "[MISS]",
    "ERROR" = "[ERR]",
    "[?]"
  )
}

# Main verification loop
all_results <- list()
missing_packages <- c()
failed_tests <- c()

cat("\nPackage Status Report:\n")
cat(paste(rep("-", 60), collapse = ""), "\n")

for (category in names(required_packages)) {
  cat(sprintf("\n%s:\n", toupper(category)))
  
  for (pkg in required_packages[[category]]) {
    result <- check_package(pkg)
    all_results[[pkg]] <- result
    
    # Format output
    symbol <- get_status_symbol(result$status)
    status_msg <- sprintf("  %-15s %s %s", pkg, symbol, result$msg)
    cat(status_msg, "\n")
    
    # Track issues
    if (result$status == "NOT_INSTALLED") {
      missing_packages <- c(missing_packages, pkg)
    } else if (result$status %in% c("WARNING", "ERROR")) {
      failed_tests <- c(failed_tests, pkg)
    }
  }
}

# Summary Report
cat("\n", paste(rep("=", 60), collapse = ""), "\n")
cat("VERIFICATION SUMMARY\n")
cat(paste(rep("=", 60), collapse = ""), "\n")

total_packages <- length(unlist(required_packages))
working_packages <- sum(sapply(all_results, function(x) x$status == "WORKING"))
warning_packages <- sum(sapply(all_results, function(x) x$status %in% c("WARNING", "ERROR")))
missing_count <- length(missing_packages)

cat(sprintf("Working:     %d/%d packages\n", working_packages, total_packages))
cat(sprintf("Warnings:    %d/%d packages\n", warning_packages, total_packages))
cat(sprintf("Missing:     %d/%d packages\n", missing_count, total_packages))

# Installation commands for missing packages
if (length(missing_packages) > 0) {
  cat("\nINSTALLATION COMMANDS:\n")
  cat(paste(rep("-", 40), collapse = ""), "\n")
  for (pkg in missing_packages) {
    cat(sprintf("%s\n", get_install_cmd(pkg)))
  }
}

# Warning details
if (length(failed_tests) > 0) {
  cat("\nPACKAGES WITH TEST FAILURES:\n")
  cat(paste(rep("-", 40), collapse = ""), "\n")
  for (pkg in failed_tests) {
    cat(sprintf("* %s: %s\n", pkg, all_results[[pkg]]$msg))
  }
}

# System info for debugging
cat("\nSYSTEM INFORMATION:\n")
cat(paste(rep("-", 40), collapse = ""), "\n")
cat(sprintf("R Version:     %s\n", R.version.string))
cat(sprintf("Platform:      %s\n", R.version$platform))
cat(sprintf("OS:            %s\n", Sys.info()["sysname"]))

# Python integration check
if ("reticulate" %in% names(all_results) && all_results[["reticulate"]]$status == "WORKING") {
  suppressMessages(library(reticulate, quietly = TRUE))
  cat(sprintf("Python Available: %s\n", py_available()))
  if (py_available()) {
    py_info <- tryCatch({
      py_config()$version
    }, error = function(e) "Unknown")
    cat(sprintf("Python Version: %s\n", py_info))
  }
}

# Final status
cat("\nORAIL READINESS:\n")
cat(paste(rep("-", 40), collapse = ""), "\n")

if (missing_count == 0 && length(failed_tests) == 0) {
  cat("ALL SYSTEMS GO! Ready for ORAIL GeoPoverty Mapping.\n")
} else if (missing_count > 0) {
  cat("Install missing packages first, then re-run verification.\n")
} else {
  cat("Some packages have issues. Check warnings above.\n")
}

cat("\nVerification complete! Ready to build 3D poverty maps.\n")
