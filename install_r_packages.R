packages <- c("rayshader", "terra", "elevatr", "sf", "magick", "rgl", "tidyverse", "reticulate", "tmap", "leaflet", "raster", "sp", "rgdal", "RColorBrewer", "viridis")

cat("ORAIL R Package Installation Starting...\n")
cat("=========================================\n")

for (pkg in packages) {
  cat(sprintf("Checking %s... ", pkg))
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat("INSTALLING\n")
    install.packages(pkg, dependencies = TRUE, repos = "https://cloud.r-project.org")
  } else {
    cat("ALREADY INSTALLED\n")
  }
}

cat("\n=========================================\n")
cat("Installation complete!\n")

# Test key packages
cat("\nTesting key packages:\n")

# Test rayshader
tryCatch({
  library(rayshader, quietly = TRUE)
  cat("SUCCESS: rayshader loaded\n")
}, error = function(e) {
  cat("ERROR: rayshader failed to load\n")
})

# Test sf
tryCatch({
  library(sf, quietly = TRUE)
  cat("SUCCESS: sf loaded\n")
}, error = function(e) {
  cat("ERROR: sf failed to load\n")
})

# Test reticulate
tryCatch({
  library(reticulate, quietly = TRUE)
  cat("SUCCESS: reticulate loaded\n")
}, error = function(e) {
  cat("ERROR: reticulate failed to load\n")
})

cat("ORAIL R environment ready!\n")
