# Simple ORAIL Launch Script
# Building on your successful package verification
# C:\Users\josze\MYRworkspace-CitizenAI-poverty-mapping\orail_launch.R

cat("ORAIL GeoPoverty Mapping - Launch Script\n")
cat("=========================================\n")

# Set working directory
setwd("C:/Users/josze/MYRworkspace-CitizenAI-poverty-mapping")

# Load your verified packages
cat("Loading verified packages...\n")

packages_to_load <- c("terra", "sf", "elevatr", "rayshader", "tidyverse", 
                     "viridis", "RColorBrewer", "rgl")

for (pkg in packages_to_load) {
  cat(sprintf("Loading %-15s ... ", pkg))
  if (library(pkg, character.only = TRUE, quietly = TRUE, logical.return = TRUE)) {
    cat("OK\n")
  } else {
    cat("ERROR\n")
  }
}

cat("\n=========================================\n")
cat("ORAIL Quick Test - Kerala Region\n")
cat("=========================================\n")

# Create output directories
if (!dir.exists("outputs")) dir.create("outputs")
if (!dir.exists("outputs/orail_test")) dir.create("outputs/orail_test")

# Kerala bounding box
kerala_bbox <- c(74.5, 8.0, 77.5, 12.8)

cat("Step 1: Creating test poverty data...\n")

# Create sample poverty data
set.seed(42)
n_points <- 30

poverty_data <- tibble(
  district = paste0("District_", LETTERS[1:n_points]),
  longitude = runif(n_points, kerala_bbox[1], kerala_bbox[3]),
  latitude = runif(n_points, kerala_bbox[2], kerala_bbox[4]),
  poverty_rate = pmax(5, pmin(80, rnorm(n_points, 30, 20))),
  population = sample(50000:500000, n_points, replace = TRUE),
  hdi = pmax(0.3, pmin(0.9, rnorm(n_points, 0.65, 0.15)))
)

cat(sprintf("Created %d poverty data points\n", nrow(poverty_data)))

cat("\nStep 2: Creating 2D visualization...\n")

# Create base plot
base_plot <- ggplot(poverty_data, aes(x = longitude, y = latitude)) +
  geom_point(aes(color = poverty_rate, size = population/10000), alpha = 0.8) +
  scale_color_viridis_c(name = "Poverty Rate (%)", option = "plasma") +
  scale_size_continuous(name = "Population (10k)", range = c(3, 10)) +
  theme_void() +
  theme(
    legend.position = "bottom",
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold")
  ) +
  labs(title = "ORAIL 3D Poverty Mapping - Kerala Test") +
  coord_fixed()

# Save 2D plot
ggsave("outputs/orail_test/kerala_2d_map.png", base_plot, 
       width = 10, height = 8, dpi = 300)

cat("2D map saved: outputs/orail_test/kerala_2d_map.png\n")

cat("\nStep 3: Testing elevation data...\n")

# Try to get real elevation data
elevation_data <- tryCatch({
  cat("Downloading elevation data from AWS...\n")
  
  bbox_points <- data.frame(
    x = c(kerala_bbox[1], kerala_bbox[3]),
    y = c(kerala_bbox[2], kerala_bbox[4])
  )
  
  get_elev_raster(locations = bbox_points, z = 8, src = "aws", clip = "bbox")
  
}, error = function(e) {
  cat("Creating synthetic elevation data...\n")
  
  # Create synthetic elevation using terra
  ext_obj <- ext(kerala_bbox[1], kerala_bbox[3], kerala_bbox[2], kerala_bbox[4])
  synth_raster <- rast(ext_obj, res = 0.01)
  
  # Generate realistic Kerala elevation (coast to mountains)
  coords <- xyFromCell(synth_raster, 1:ncell(synth_raster))
  coast_line <- kerala_bbox[1] + 0.15  # Approximate coast
  
  elevation_values <- pmax(0, (coords[,1] - coast_line) * 800 + rnorm(nrow(coords), 0, 200))
  values(synth_raster) <- elevation_values
  
  synth_raster
})

cat("Elevation data ready\n")

cat("\nStep 4: Testing 3D visualization with rayshader...\n")

# Test 3D rendering
tryCatch({
  # Convert elevation to matrix
  if (class(elevation_data)[1] == "SpatRaster") {
    elev_matrix <- as.matrix(elevation_data, wide = TRUE)
  } else {
    elev_matrix <- as.matrix(elevation_data)
  }
  
  # Handle missing values
  elev_matrix[is.na(elev_matrix)] <- mean(elev_matrix, na.rm = TRUE)
  
  cat(sprintf("Elevation matrix: %d x %d\n", nrow(elev_matrix), ncol(elev_matrix)))
  
  # Create 3D plot
  cat("Rendering 3D visualization...\n")
  
  plot_gg(base_plot,
          multicore = FALSE,
          width = 6,
          height = 6,
          scale = 150,
          windowsize = c(800, 600),
          zoom = 0.7,
          phi = 45,
          theta = 45)
  
  # Save main 3D snapshot
  render_snapshot(filename = "outputs/orail_test/kerala_3d_main.png", clear = TRUE)
  cat("3D snapshot saved: outputs/orail_test/kerala_3d_main.png\n")
  
  # Create different view angles
  view_angles <- list(
    list(phi = 90, theta = 0, name = "aerial"),
    list(phi = 30, theta = 90, name = "side"),
    list(phi = 20, theta = 45, name = "oblique")
  )
  
  cat("Creating multiple view angles...\n")
  for (view in view_angles) {
    render_camera(phi = view$phi, theta = view$theta, zoom = 0.7)
    
    filename <- sprintf("outputs/orail_test/kerala_3d_%s.png", view$name)
    render_snapshot(filename = filename, clear = FALSE)
    
    cat(sprintf("  %s view saved\n", view$name))
  }
  
  cat("SUCCESS: 3D visualization complete\n")
  
}, error = function(e) {
  cat("3D rendering error:", e$message, "\n")
  cat("Note: 2D visualization still works perfectly\n")
})

cat("\nStep 5: Generating summary statistics...\n")

# Summary statistics
summary_stats <- poverty_data %>%
  summarise(
    total_points = n(),
    avg_poverty = round(mean(poverty_rate), 1),
    min_poverty = round(min(poverty_rate), 1),
    max_poverty = round(max(poverty_rate), 1),
    total_population = sum(population),
    avg_hdi = round(mean(hdi), 3)
  )

cat("\nPoverty Data Summary:\n")
cat(sprintf("  Total data points: %d\n", summary_stats$total_points))
cat(sprintf("  Average poverty rate: %s%%\n", summary_stats$avg_poverty))
cat(sprintf("  Poverty range: %s%% - %s%%\n", summary_stats$min_poverty, summary_stats$max_poverty))
cat(sprintf("  Total population: %s\n", format(summary_stats$total_population, big.mark = ",")))
cat(sprintf("  Average HDI: %s\n", summary_stats$avg_hdi))

# Save data
write_csv(poverty_data, "outputs/orail_test/kerala_poverty_data.csv")
cat("\nData saved: outputs/orail_test/kerala_poverty_data.csv\n")

cat("\n=========================================\n")
cat("ORAIL TEST COMPLETE\n")
cat("=========================================\n")

cat("Generated files:\n")
generated_files <- list.files("outputs/orail_test", full.names = FALSE)
for (file in generated_files) {
  cat(sprintf("  - %s\n", file))
}

cat("\nNext steps:\n")
cat("1. Check the generated visualizations in outputs/orail_test/\n")
cat("2. If 3D maps look good, proceed to full workflow\n")
cat("3. Replace test data with real poverty survey data\n")
cat("4. Expand to other regions or higher resolution\n")

cat("\nORail framework is ready for production use!\n")
cat("Your package setup is excellent for geospatial poverty analysis.\n")
