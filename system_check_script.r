# ORAIL CITIZEN AI - Comprehensive System Check and Environment Setup
# Author: Joseph V Thomas (ORAIL)
# Project: Geospatial Poverty Mapping Framework
# Target Directory: C:\Users\josze\MYRworkspace-CitizenAI-poverty-mapping

# ============================================================================
# SYSTEM ENVIRONMENT DETECTION AND MAPPING
# ============================================================================

library(fs)
library(purrr)
library(dplyr)
library(stringr)

# Set project workspace
PROJECT_ROOT <- "C:/Users/josze/MYRworkspace-CitizenAI-poverty-mapping"

cat("=================================================================\n")
cat("ORAIL CITIZEN AI - SYSTEM ENVIRONMENT DETECTION\n")
cat("=================================================================\n")
cat("Project Workspace:", PROJECT_ROOT, "\n")
cat("System User:", Sys.getenv("USERNAME"), "\n")
cat("System Date:", Sys.Date(), "\n\n")

# ============================================================================
# 1. DETECT R ENVIRONMENT AND LIBRARIES
# ============================================================================

detect_r_environment <- function() {
  cat("1. R ENVIRONMENT ANALYSIS\n")
  cat("-------------------------------------------\n")
  
  # R Installation Details
  r_info <- list(
    version = R.version.string,
    home = R.home(),
    platform = R.version$platform,
    arch = R.version$arch,
    major = R.version$major,
    minor = R.version$minor,
    library_paths = .libPaths(),
    installed_packages = nrow(installed.packages())
  )
  
  cat("R Version:", r_info$version, "\n")
  cat("R Home:", r_info$home, "\n")
  cat("Platform:", r_info$platform, "\n")
  cat("Architecture:", r_info$arch, "\n")
  cat("Library Paths:\n")
  for(i in seq_along(r_info$library_paths)) {
    cat("  [", i, "]", r_info$library_paths[i], "\n")
  }
  cat("Total Installed Packages:", r_info$installed_packages, "\n")
  
  # Check for essential packages
  essential_packages <- c(
    "sf", "terra", "stars", "leaflet", "mapview", "tmap", "rayshader", "rgl",
    "tensorflow", "keras", "torch", "randomForest", "xgboost", "caret", "mlr3",
    "plotly", "shiny", "htmlwidgets", "data.table", "dplyr", "arrow",
    "rgee", "RStoolbox", "satellite", "httr2", "jsonlite"
  )
  
  cat("\nESSENTIAL PACKAGES STATUS:\n")
  package_status <- data.frame(
    Package = essential_packages,
    Installed = sapply(essential_packages, function(x) x %in% rownames(installed.packages())),
    Version = sapply(essential_packages, function(x) {
      if(x %in% rownames(installed.packages())) {
        as.character(packageVersion(x))
      } else {
        "Not Installed"
      }
    }),
    stringsAsFactors = FALSE
  )
  
  print(package_status)
  
  return(r_info)
}

# ============================================================================
# 2. DETECT PYTHON AND AI/ML LIBRARIES
# ============================================================================

detect_python_environment <- function() {
  cat("\n\n2. PYTHON ENVIRONMENT ANALYSIS\n")
  cat("-------------------------------------------\n")
  
  # Find Python installations
  python_paths <- c()
  
  # Common Python installation paths
  common_paths <- c(
    "C:/Python*/python.exe",
    "C:/Users/*/AppData/Local/Programs/Python/Python*/python.exe",
    "C:/Users/*/Anaconda*/python.exe",
    "C:/Users/*/Miniconda*/python.exe",
    "C:/ProgramData/Anaconda*/python.exe",
    "C:/ProgramData/Miniconda*/python.exe"
  )
  
  for(path_pattern in common_paths) {
    found_paths <- Sys.glob(path_pattern)
    python_paths <- c(python_paths, found_paths)
  }
  
  # Check system PATH for python
  tryCatch({
    system_python <- system("where python", intern = TRUE, ignore.stderr = TRUE)
    python_paths <- c(python_paths, system_python)
  }, error = function(e) {})
  
  python_paths <- unique(python_paths)
  
  cat("Found Python Installations:\n")
  for(i in seq_along(python_paths)) {
    cat("  [", i, "]", python_paths[i], "\n")
    
    # Get Python version
    tryCatch({
      version_cmd <- paste0('"', python_paths[i], '" --version')
      version <- system(version_cmd, intern = TRUE, ignore.stderr = TRUE)
      cat("      Version:", version, "\n")
    }, error = function(e) {
      cat("      Version: Unable to detect\n")
    })
  }
  
  # Check for essential Python packages
  essential_py_packages <- c(
    "tensorflow", "torch", "scikit-learn", "pandas", "numpy", "matplotlib",
    "geopandas", "rasterio", "shapely", "fiona", "gdal", "openai", "anthropic"
  )
  
  cat("\nPYTHON PACKAGES CHECK (using primary Python):\n")
  if(length(python_paths) > 0) {
    primary_python <- python_paths[1]
    for(pkg in essential_py_packages) {
      tryCatch({
        check_cmd <- paste0('"', primary_python, '" -c "import ', pkg, '; print(', pkg, '.__version__)"')
        version <- system(check_cmd, intern = TRUE, ignore.stderr = TRUE)
        cat("  ", pkg, ":", if(length(version) > 0) version[1] else "Not Found", "\n")
      }, error = function(e) {
        cat("  ", pkg, ": Not Found\n")
      })
    }
  }
  
  return(python_paths)
}

# ============================================================================
# 3. DETECT IDES AND DEVELOPMENT ENVIRONMENTS
# ============================================================================

detect_ides <- function() {
  cat("\n\n3. IDE AND DEVELOPMENT TOOLS\n")
  cat("-------------------------------------------\n")
  
  ide_info <- list()
  
  # RStudio Detection
  rstudio_paths <- c(
    "C:/Program Files/RStudio/bin/rstudio.exe",
    "C:/Program Files (x86)/RStudio/bin/rstudio.exe",
    "C:/Users/*/AppData/Local/RStudio-Desktop/bin/rstudio.exe"
  )
  
  found_rstudio <- c()
  for(path in rstudio_paths) {
    found <- Sys.glob(path)
    found_rstudio <- c(found_rstudio, found)
  }
  
  if(length(found_rstudio) > 0) {
    cat("RStudio Desktop:\n")
    for(path in found_rstudio) {
      cat("  ", path, "\n")
      # Try to get version
      tryCatch({
        version_info <- system(paste0('"', path, '" --version'), intern = TRUE, ignore.stderr = TRUE)
        if(length(version_info) > 0) cat("  Version:", version_info[1], "\n")
      }, error = function(e) {})
    }
    ide_info$rstudio <- found_rstudio
  } else {
    cat("RStudio Desktop: Not Found\n")
  }
  
  # Visual Studio Code Detection
  vscode_paths <- c(
    "C:/Program Files/Microsoft VS Code/Code.exe",
    "C:/Program Files (x86)/Microsoft VS Code/Code.exe",
    "C:/Users/*/AppData/Local/Programs/Microsoft VS Code/Code.exe"
  )
  
  found_vscode <- c()
  for(path in vscode_paths) {
    found <- Sys.glob(path)
    found_vscode <- c(found_vscode, found)
  }
  
  if(length(found_vscode) > 0) {
    cat("\nVisual Studio Code:\n")
    for(path in found_vscode) {
      cat("  ", path, "\n")
    }
    ide_info$vscode <- found_vscode
  } else {
    cat("\nVisual Studio Code: Not Found\n")
  }
  
  # Jupyter Detection (via Python)
  tryCatch({
    jupyter_check <- system("jupyter --version", intern = TRUE, ignore.stderr = TRUE)
    if(length(jupyter_check) > 0) {
      cat("\nJupyter:\n")
      for(line in jupyter_check) {
        cat("  ", line, "\n")
      }
      ide_info$jupyter <- TRUE
    }
  }, error = function(e) {
    cat("\nJupyter: Not Found\n")
  })
  
  # PyCharm Detection
  pycharm_paths <- c(
    "C:/Program Files/JetBrains/PyCharm*/bin/pycharm64.exe",
    "C:/Users/*/AppData/Local/JetBrains/PyCharm*/bin/pycharm64.exe"
  )
  
  found_pycharm <- c()
  for(path in pycharm_paths) {
    found <- Sys.glob(path)
    found_pycharm <- c(found_pycharm, found)
  }
  
  if(length(found_pycharm) > 0) {
    cat("\nPyCharm:\n")
    for(path in found_pycharm) {
      cat("  ", path, "\n")
    }
    ide_info$pycharm <- found_pycharm
  } else {
    cat("\nPyCharm: Not Found\n")
  }
  
  return(ide_info)
}

# ============================================================================
# 4. DETECT CUDA AND GPU SUPPORT
# ============================================================================

detect_cuda_gpu <- function() {
  cat("\n\n4. CUDA AND GPU ANALYSIS\n")
  cat("-------------------------------------------\n")
  
  gpu_info <- list()
  
  # NVIDIA GPU Detection
  tryCatch({
    nvidia_smi <- system("nvidia-smi", intern = TRUE, ignore.stderr = TRUE)
    if(length(nvidia_smi) > 0) {
      cat("NVIDIA GPU DETECTED:\n")
      for(line in nvidia_smi[1:min(15, length(nvidia_smi))]) {
        cat(line, "\n")
      }
      gpu_info$nvidia_gpu <- TRUE
    }
  }, error = function(e) {
    cat("NVIDIA GPU: Not detected or nvidia-smi not available\n")
    gpu_info$nvidia_gpu <- FALSE
  })
  
  # CUDA Detection
  cuda_paths <- c(
    "C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/*/bin/nvcc.exe",
    "C:/Program Files (x86)/NVIDIA GPU Computing Toolkit/CUDA/*/bin/nvcc.exe"
  )
  
  found_cuda <- c()
  for(path in cuda_paths) {
    found <- Sys.glob(path)
    found_cuda <- c(found_cuda, found)
  }
  
  if(length(found_cuda) > 0) {
    cat("\nCUDA INSTALLATIONS:\n")
    for(path in found_cuda) {
      cat("  ", path, "\n")
      # Get CUDA version
      tryCatch({
        version_cmd <- paste0('"', path, '" --version')
        version_info <- system(version_cmd, intern = TRUE, ignore.stderr = TRUE)
        if(length(version_info) > 0) {
          version_line <- version_info[grep("release", version_info)][1]
          if(!is.na(version_line)) cat("  Version:", version_line, "\n")
        }
      }, error = function(e) {})
    }
    gpu_info$cuda_paths <- found_cuda
  } else {
    cat("\nCUDA: Not Found\n")
  }
  
  # cuDNN Detection
  cudnn_paths <- c(
    "C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/*/include/cudnn.h",
    "C:/tools/cuda/include/cudnn.h"
  )
  
  found_cudnn <- c()
  for(path in cudnn_paths) {
    found <- Sys.glob(path)
    found_cudnn <- c(found_cudnn, found)
  }
  
  if(length(found_cudnn) > 0) {
    cat("\ncuDNN DETECTED:\n")
    for(path in found_cudnn) {
      cat("  ", path, "\n")
    }
    gpu_info$cudnn <- found_cudnn
  } else {
    cat("\ncuDNN: Not Found\n")
  }
  
  return(gpu_info)
}

# ============================================================================
# 5. DETECT DATABASE SYSTEMS
# ============================================================================

detect_databases <- function() {
  cat("\n\n5. DATABASE SYSTEMS\n")
  cat("-------------------------------------------\n")
  
  db_info <- list()
  
  # PostgreSQL Detection
  postgres_paths <- c(
    "C:/Program Files/PostgreSQL/*/bin/psql.exe",
    "C:/Program Files (x86)/PostgreSQL/*/bin/psql.exe"
  )
  
  found_postgres <- c()
  for(path in postgres_paths) {
    found <- Sys.glob(path)
    found_postgres <- c(found_postgres, found)
  }
  
  if(length(found_postgres) > 0) {
    cat("PostgreSQL:\n")
    for(path in found_postgres) {
      cat("  ", path, "\n")
      # Get version
      tryCatch({
        version_cmd <- paste0('"', path, '" --version')
        version <- system(version_cmd, intern = TRUE, ignore.stderr = TRUE)
        if(length(version) > 0) cat("  Version:", version[1], "\n")
      }, error = function(e) {})
    }
    db_info$postgresql <- found_postgres
  } else {
    cat("PostgreSQL: Not Found\n")
  }
  
  # SQLite Detection (usually comes with R)
  tryCatch({
    if(require(RSQLite, quietly = TRUE)) {
      cat("\nSQLite: Available via RSQLite package\n")
      db_info$sqlite <- TRUE
    }
  }, error = function(e) {
    cat("\nSQLite: Not available\n")
  })
  
  # MongoDB Detection
  mongo_paths <- c(
    "C:/Program Files/MongoDB/*/bin/mongo.exe",
    "C:/Program Files (x86)/MongoDB/*/bin/mongo.exe"
  )
  
  found_mongo <- c()
  for(path in mongo_paths) {
    found <- Sys.glob(path)
    found_mongo <- c(found_mongo, found)
  }
  
  if(length(found_mongo) > 0) {
    cat("\nMongoDB:\n")
    for(path in found_mongo) {
      cat("  ", path, "\n")
    }
    db_info$mongodb <- found_mongo
  } else {
    cat("\nMongoDB: Not Found\n")
  }
  
  return(db_info)
}

# ============================================================================
# 6. DETECT GEOSPATIAL LIBRARIES
# ============================================================================

detect_geospatial_libs <- function() {
  cat("\n\n6. GEOSPATIAL LIBRARIES\n")
  cat("-------------------------------------------\n")
  
  geo_info <- list()
  
  # GDAL Detection
  tryCatch({
    gdal_info <- system("gdalinfo --version", intern = TRUE, ignore.stderr = TRUE)
    if(length(gdal_info) > 0) {
      cat("GDAL:", gdal_info[1], "\n")
      geo_info$gdal <- gdal_info[1]
    }
  }, error = function(e) {
    cat("GDAL: Not found in system PATH\n")
  })
  
  # Check GDAL via R packages
  tryCatch({
    if(require(sf, quietly = TRUE)) {
      gdal_version <- sf::sf_extSoftVersion()["GDAL"]
      cat("GDAL (via sf package):", gdal_version, "\n")
      geo_info$gdal_r <- gdal_version
    }
  }, error = function(e) {})
  
  # PROJ Detection
  tryCatch({
    if(require(sf, quietly = TRUE)) {
      proj_version <- sf::sf_extSoftVersion()["PROJ"]
      cat("PROJ:", proj_version, "\n")
      geo_info$proj <- proj_version
    }
  }, error = function(e) {
    cat("PROJ: Not available\n")
  })
  
  # GEOS Detection
  tryCatch({
    if(require(sf, quietly = TRUE)) {
      geos_version <- sf::sf_extSoftVersion()["GEOS"]
      cat("GEOS:", geos_version, "\n")
      geo_info$geos <- geos_version
    }
  }, error = function(e) {
    cat("GEOS: Not available\n")
  })
  
  return(geo_info)
}

# ============================================================================
# 7. DETECT LLM AND AI TOOLS
# ============================================================================

detect_llm_tools <- function() {
  cat("\n\n7. LLM AND AI TOOLS\n")
  cat("-------------------------------------------\n")
  
  llm_info <- list()
  
  # Check for Ollama
  tryCatch({
    ollama_version <- system("ollama --version", intern = TRUE, ignore.stderr = TRUE)
    if(length(ollama_version) > 0) {
      cat("Ollama:", ollama_version[1], "\n")
      
      # List installed models
      tryCatch({
        models <- system("ollama list", intern = TRUE, ignore.stderr = TRUE)
        if(length(models) > 1) {
          cat("  Installed Models:\n")
          for(model in models[-1]) {  # Skip header
            cat("    ", model, "\n")
          }
        }
      }, error = function(e) {})
      
      llm_info$ollama <- ollama_version[1]
    }
  }, error = function(e) {
    cat("Ollama: Not Found\n")
  })
  
  # Check for OpenAI package
  tryCatch({
    if(require(openai, quietly = TRUE)) {
      cat("OpenAI R Package: Available\n")
      llm_info$openai_r <- TRUE
    }
  }, error = function(e) {
    cat("OpenAI R Package: Not installed\n")
  })
  
  # Check for Python AI packages
  ai_packages <- c("openai", "anthropic", "langchain", "transformers")
  cat("\nPython AI Packages:\n")
  for(pkg in ai_packages) {
    tryCatch({
      check_cmd <- paste0('python -c "import ', pkg, '; print(\'', pkg, ':\', ', pkg, '.__version__)"')
      result <- system(check_cmd, intern = TRUE, ignore.stderr = TRUE)
      if(length(result) > 0) {
        cat("  ", result[1], "\n")
      } else {
        cat("  ", pkg, ": Not Found\n")
      }
    }, error = function(e) {
      cat("  ", pkg, ": Not Found\n")
    })
  }
  
  return(llm_info)
}

# ============================================================================
# 8. CREATE PROJECT DIRECTORY STRUCTURE
# ============================================================================

setup_project_structure <- function() {
  cat("\n\n8. PROJECT DIRECTORY SETUP\n")
  cat("-------------------------------------------\n")
  
  # Create main project directory
  if(!dir.exists(PROJECT_ROOT)) {
    dir.create(PROJECT_ROOT, recursive = TRUE)
    cat("Created main project directory:", PROJECT_ROOT, "\n")
  } else {
    cat("Project directory exists:", PROJECT_ROOT, "\n")
  }
  
  # Define subdirectories
  subdirs <- c(
    "data/raw/satellite",
    "data/raw/census", 
    "data/raw/osm",
    "data/raw/mobile",
    "data/processed",
    "data/cache",
    "models/trained",
    "models/configs",
    "outputs/maps",
    "outputs/reports", 
    "outputs/visualizations",
    "scripts/r",
    "scripts/python",
    "scripts/sql",
    "config",
    "logs",
    "temp",
    "docs",
    "notebooks"
  )
  
  # Create subdirectories
  for(subdir in subdirs) {
    full_path <- file.path(PROJECT_ROOT, subdir)
    if(!dir.exists(full_path)) {
      dir.create(full_path, recursive = TRUE)
      cat("Created:", full_path, "\n")
    }
  }
  
  # Create configuration files
  config_content <- paste0(
    "# ORAIL CITIZEN AI Project Configuration\n",
    "# Generated: ", Sys.time(), "\n",
    "# User: ", Sys.getenv("USERNAME"), "\n\n",
    "PROJECT_ROOT: '", PROJECT_ROOT, "'\n",
    "DATA_ROOT: '", file.path(PROJECT_ROOT, "data"), "'\n",
    "MODELS_ROOT: '", file.path(PROJECT_ROOT, "models"), "'\n",
    "OUTPUTS_ROOT: '", file.path(PROJECT_ROOT, "outputs"), "'\n",
    "SCRIPTS_ROOT: '", file.path(PROJECT_ROOT, "scripts"), "'\n"
  )
  
  writeLines(config_content, file.path(PROJECT_ROOT, "config", "project_config.yaml"))
  
  # Create R environment file
  r_env_content <- paste0(
    "# R Environment Configuration for ORAIL CITIZEN AI\n",
    "# Generated: ", Sys.time(), "\n\n",
    ".libPaths(c('", paste(.libPaths(), collapse = "', '"), "'))\n",
    "options(repos = c(CRAN = 'https://cran.r-project.org/'))\n",
    "options(timeout = 300)\n",
    "options(mc.cores = ", parallel::detectCores(), ")\n\n",
    "# Project paths\n",
    "PROJECT_ROOT <- '", PROJECT_ROOT, "'\n",
    "setwd(PROJECT_ROOT)\n"
  )
  
  writeLines(r_env_content, file.path(PROJECT_ROOT, "config", "r_environment.R"))
  
  cat("\nProject structure created successfully!\n")
  
  return(file.path(PROJECT_ROOT, "config"))
}

# ============================================================================
# 9. GENERATE SYSTEM MAPPING REPORT
# ============================================================================

generate_system_report <- function(r_info, python_paths, ide_info, gpu_info, db_info, geo_info, llm_info) {
  cat("\n\n9. SYSTEM MAPPING SUMMARY\n")
  cat("=================================================================\n")
  
  # Create comprehensive report
  report_content <- paste0(
    "# ORAIL CITIZEN AI - System Environment Report\n",
    "Generated: ", Sys.time(), "\n",
    "User: ", Sys.getenv("USERNAME"), "\n",
    "Project Root: ", PROJECT_ROOT, "\n\n",
    
    "## R Environment\n",
    "- Version: ", r_info$version, "\n",
    "- Home: ", r_info$home, "\n",
    "- Platform: ", r_info$platform, "\n",
    "- Installed Packages: ", r_info$installed_packages, "\n\n",
    
    "## Python Environment\n"
  )
  
  if(length(python_paths) > 0) {
    report_content <- paste0(report_content, "- Primary Python: ", python_paths[1], "\n")
    for(i in seq_along(python_paths)) {
      report_content <- paste0(report_content, "- Python [", i, "]: ", python_paths[i], "\n")
    }
  } else {
    report_content <- paste0(report_content, "- No Python installations detected\n")
  }
  
  report_content <- paste0(report_content, "\n## Development Tools\n")
  if(!is.null(ide_info$rstudio)) {
    report_content <- paste0(report_content, "- RStudio: ", ide_info$rstudio[1], "\n")
  }
  if(!is.null(ide_info$vscode)) {
    report_content <- paste0(report_content, "- VS Code: ", ide_info$vscode[1], "\n")
  }
  
  report_content <- paste0(report_content, "\n## GPU/CUDA Support\n")
  report_content <- paste0(report_content, "- NVIDIA GPU: ", ifelse(gpu_info$nvidia_gpu, "Available", "Not detected"), "\n")
  if(!is.null(gpu_info$cuda_paths)) {
    report_content <- paste0(report_content, "- CUDA: ", gpu_info$cuda_paths[1], "\n")
  }
  
  # Save report
  report_path <- file.path(PROJECT_ROOT, "docs", "system_environment_report.md")
  writeLines(report_content, report_path)
  
  cat("System report saved to:", report_path, "\n")
  
  # Print quick summary
  cat("\nQUICK SUMMARY:\n")
  cat("✓ R Environment: ", r_info$version, "\n")
  cat("✓ Project Directory: ", PROJECT_ROOT, "\n")
  cat("✓ Python Available: ", ifelse(length(python_paths) > 0, "Yes", "No"), "\n")
  cat("✓ GPU Support: ", ifelse(gpu_info$nvidia_gpu, "Yes", "No"), "\n")
  cat("✓ Geospatial Libraries: ", ifelse(!is.null(geo_info$gdal), "Available", "Limited"), "\n")
  
  return(report_path)
}

# ============================================================================
# 10. DETECT ALL PROGRAMMING LANGUAGES AND RUNTIMES
# ============================================================================

detect_all_programming_environments <- function() {
  cat("\n\n10. PROGRAMMING LANGUAGES & RUNTIMES\n")
  cat("-------------------------------------------\n")
  
  lang_info <- list()
  
  # Java Detection
  tryCatch({
    java_version <- system("java -version", intern = TRUE, ignore.stderr = TRUE)
    if(length(java_version) > 0) {
      cat("Java:\n")
      for(line in java_version) cat("  ", line, "\n")
      lang_info$java <- java_version[1]
    }
  }, error = function(e) {
    cat("Java: Not Found\n")
  })
  
  # Node.js Detection
  tryCatch({
    node_version <- system("node --version", intern = TRUE, ignore.stderr = TRUE)
    npm_version <- system("npm --version", intern = TRUE, ignore.stderr = TRUE)
    if(length(node_version) > 0) {
      cat("Node.js:", node_version[1], "\n")
      if(length(npm_version) > 0) cat("NPM:", npm_version[1], "\n")
      lang_info$nodejs <- node_version[1]
      lang_info$npm <- npm_version[1]
    }
  }, error = function(e) {
    cat("Node.js: Not Found\n")
  })
  
  # Julia Detection
  tryCatch({
    julia_version <- system("julia --version", intern = TRUE, ignore.stderr = TRUE)
    if(length(julia_version) > 0) {
      cat("Julia:", julia_version[1], "\n")
      lang_info$julia <- julia_version[1]
    }
  }, error = function(e) {
    cat("Julia: Not Found\n")
  })
  
  # Rust Detection
  tryCatch({
    rust_version <- system("rustc --version", intern = TRUE, ignore.stderr = TRUE)
    if(length(rust_version) > 0) {
      cat("Rust:", rust_version[1], "\n")
      lang_info$rust <- rust_version[1]
    }
  }, error = function(e) {
    cat("Rust: Not Found\n")
  })
  
  # Go Detection
  tryCatch({
    go_version <- system("go version", intern = TRUE, ignore.stderr = TRUE)
    if(length(go_version) > 0) {
      cat("Go:", go_version[1], "\n")
      lang_info$go <- go_version[1]
    }
  }, error = function(e) {
    cat("Go: Not Found\n")
  })
  
  return(lang_info)
}

# ============================================================================
# 11. DETECT CONTAINERIZATION AND VIRTUALIZATION
# ============================================================================

detect_containerization <- function() {
  cat("\n\n11. CONTAINERIZATION & VIRTUALIZATION\n")
  cat("-------------------------------------------\n")
  
  container_info <- list()
  
  # Docker Detection
  tryCatch({
    docker_version <- system("docker --version", intern = TRUE, ignore.stderr = TRUE)
    if(length(docker_version) > 0) {
      cat("Docker:", docker_version[1], "\n")
      
      # Docker Compose
      compose_version <- system("docker-compose --version", intern = TRUE, ignore.stderr = TRUE)
      if(length(compose_version) > 0) {
        cat("Docker Compose:", compose_version[1], "\n")
      }
      
      # Docker status
      docker_status <- system("docker info", intern = TRUE, ignore.stderr = TRUE)
      if(length(docker_status) > 0) {
        cat("Docker Status: Running\n")
      }
      
      container_info$docker <- docker_version[1]
    }
  }, error = function(e) {
    cat("Docker: Not Found\n")
  })
  
  # Kubernetes Detection
  tryCatch({
    kubectl_version <- system("kubectl version --client", intern = TRUE, ignore.stderr = TRUE)
    if(length(kubectl_version) > 0) {
      cat("Kubectl:", kubectl_version[1], "\n")
      container_info$kubectl <- kubectl_version[1]
    }
  }, error = function(e) {
    cat("Kubectl: Not Found\n")
  })
  
  # WSL Detection
  tryCatch({
    wsl_version <- system("wsl --version", intern = TRUE, ignore.stderr = TRUE)
    if(length(wsl_version) > 0) {
      cat("WSL:\n")
      for(line in wsl_version) cat("  ", line, "\n")
      
      # List WSL distributions
      wsl_list <- system("wsl --list", intern = TRUE, ignore.stderr = TRUE)
      if(length(wsl_list) > 0) {
        cat("WSL Distributions:\n")
        for(dist in wsl_list) cat("  ", dist, "\n")
      }
      
      container_info$wsl <- wsl_version[1]
    }
  }, error = function(e) {
    cat("WSL: Not Found\n")
  })
  
  # VirtualBox Detection
  vbox_paths <- c(
    "C:/Program Files/Oracle/VirtualBox/VBoxManage.exe"
  )
  
  found_vbox <- c()
  for(path in vbox_paths) {
    if(file.exists(path)) {
      found_vbox <- c(found_vbox, path)
      tryCatch({
        vbox_version <- system(paste0('"', path, '" --version'), intern = TRUE, ignore.stderr = TRUE)
        cat("VirtualBox:", vbox_version[1], "\n")
        container_info$virtualbox <- vbox_version[1]
      }, error = function(e) {})
    }
  }
  
  if(length(found_vbox) == 0) {
    cat("VirtualBox: Not Found\n")
  }
  
  return(container_info)
}

# ============================================================================
# 12. DETECT CLOUD CLI TOOLS
# ============================================================================

detect_cloud_tools <- function() {
  cat("\n\n12. CLOUD CLI TOOLS\n")
  cat("-------------------------------------------\n")
  
  cloud_info <- list()
  
  # AWS CLI
  tryCatch({
    aws_version <- system("aws --version", intern = TRUE, ignore.stderr = TRUE)
    if(length(aws_version) > 0) {
      cat("AWS CLI:", aws_version[1], "\n")
      
      # Check AWS configuration
      tryCatch({
        aws_config <- system("aws configure list", intern = TRUE, ignore.stderr = TRUE)
        if(length(aws_config) > 0) {
          cat("AWS Configuration:\n")
          for(line in aws_config[1:min(5, length(aws_config))]) {
            cat("  ", line, "\n")
          }
        }
      }, error = function(e) {})
      
      cloud_info$aws <- aws_version[1]
    }
  }, error = function(e) {
    cat("AWS CLI: Not Found\n")
  })
  
  # Google Cloud CLI
  tryCatch({
    gcloud_version <- system("gcloud --version", intern = TRUE, ignore.stderr = TRUE)
    if(length(gcloud_version) > 0) {
      cat("Google Cloud CLI:\n")
      for(line in gcloud_version[1:min(3, length(gcloud_version))]) {
        cat("  ", line, "\n")
      }
      cloud_info$gcloud <- gcloud_version[1]
    }
  }, error = function(e) {
    cat("Google Cloud CLI: Not Found\n")
  })
  
  # Azure CLI
  tryCatch({
    az_version <- system("az --version", intern = TRUE, ignore.stderr = TRUE)
    if(length(az_version) > 0) {
      cat("Azure CLI:", az_version[1], "\n")
      cloud_info$azure <- az_version[1]
    }
  }, error = function(e) {
    cat("Azure CLI: Not Found\n")
  })
  
  return(cloud_info)
}

# ============================================================================
# 13. DETECT VERSION CONTROL SYSTEMS
# ============================================================================

detect_version_control <- function() {
  cat("\n\n13. VERSION CONTROL SYSTEMS\n")
  cat("-------------------------------------------\n")
  
  vcs_info <- list()
  
  # Git Detection
  tryCatch({
    git_version <- system("git --version", intern = TRUE, ignore.stderr = TRUE)
    if(length(git_version) > 0) {
      cat("Git:", git_version[1], "\n")
      
      # Git configuration
      tryCatch({
        git_user <- system("git config --global user.name", intern = TRUE, ignore.stderr = TRUE)
        git_email <- system("git config --global user.email", intern = TRUE, ignore.stderr = TRUE)
        if(length(git_user) > 0) cat("Git User:", git_user[1], "\n")
        if(length(git_email) > 0) cat("Git Email:", git_email[1], "\n")
      }, error = function(e) {})
      
      vcs_info$git <- git_version[1]
    }
  }, error = function(e) {
    cat("Git: Not Found\n")
  })
  
  # SVN Detection
  tryCatch({
    svn_version <- system("svn --version", intern = TRUE, ignore.stderr = TRUE)
    if(length(svn_version) > 0) {
      cat("SVN:", svn_version[1], "\n")
      vcs_info$svn <- svn_version[1]
    }
  }, error = function(e) {
    cat("SVN: Not Found\n")
  })
  
  return(vcs_info)
}

# ============================================================================
# 14. DETECT SYSTEM SPECIFICATIONS AND PERFORMANCE
# ============================================================================

detect_system_specs <- function() {
  cat("\n\n14. SYSTEM SPECIFICATIONS\n")
  cat("-------------------------------------------\n")
  
  sys_info <- list()
  
  # CPU Information
  tryCatch({
    cpu_info <- system("wmic cpu get name,numberofcores,numberoflogicalprocessors /format:list", 
                      intern = TRUE, ignore.stderr = TRUE)
    cpu_clean <- cpu_info[cpu_info != ""]
    cat("CPU Information:\n")
    for(line in cpu_clean[1:min(10, length(cpu_clean))]) {
      cat("  ", line, "\n")
    }
  }, error = function(e) {
    cat("CPU Info: Unable to retrieve\n")
  })
  
  # Memory Information
  tryCatch({
    mem_info <- system("wmic computersystem get TotalPhysicalMemory /format:list", 
                      intern = TRUE, ignore.stderr = TRUE)
    mem_clean <- mem_info[mem_info != ""]
    cat("\nMemory Information:\n")
    for(line in mem_clean) {
      cat("  ", line, "\n")
    }
  }, error = function(e) {
    cat("Memory Info: Unable to retrieve\n")
  })
  
  # Disk Information
  tryCatch({
    disk_info <- system("wmic logicaldisk get size,freespace,caption /format:list", 
                       intern = TRUE, ignore.stderr = TRUE)
    disk_clean <- disk_info[disk_info != ""]
    cat("\nDisk Information:\n")
    for(line in disk_clean[1:min(15, length(disk_clean))]) {
      cat("  ", line, "\n")
    }
  }, error = function(e) {
    cat("Disk Info: Unable to retrieve\n")
  })
  
  # Network Information
  tryCatch({
    network_info <- system("wmic path win32_networkadapter get name,netconnectionstatus /format:list", 
                          intern = TRUE, ignore.stderr = TRUE)
    network_clean <- network_info[network_info != "" & grepl("=", network_info)]
    cat("\nActive Network Adapters:\n")
    for(line in network_clean[1:min(10, length(network_clean))]) {
      if(grepl("Name=", line) || grepl("NetConnectionStatus=1", line)) {
        cat("  ", line, "\n")
      }
    }
  }, error = function(e) {
    cat("Network Info: Unable to retrieve\n")
  })
  
  return(sys_info)
}

# ============================================================================
# 15. DETECT ENVIRONMENT VARIABLES AND PATHS
# ============================================================================

detect_environment_variables <- function() {
  cat("\n\n15. ENVIRONMENT VARIABLES & PATHS\n")
  cat("-------------------------------------------\n")
  
  env_info <- list()
  
  # Important environment variables
  important_vars <- c(
    "PATH", "PYTHONPATH", "R_HOME", "R_LIBS", "JAVA_HOME", 
    "CUDA_PATH", "GDAL_DATA", "PROJ_LIB", "OPENAI_API_KEY",
    "AWS_PROFILE", "GOOGLE_APPLICATION_CREDENTIALS"
  )
  
  cat("Important Environment Variables:\n")
  for(var in important_vars) {
    value <- Sys.getenv(var)
    if(value != "") {
      # Truncate long PATH variables
      if(var == "PATH" && nchar(value) > 200) {
        cat("  ", var, ": ", substr(value, 1, 200), "... (truncated)\n")
      } else {
        cat("  ", var, ": ", value, "\n")
      }
      env_info[[var]] <- value
    } else {
      cat("  ", var, ": Not Set\n")
    }
  }
  
  # R-specific paths
  cat("\nR-Specific Paths:\n")
  cat("  R_HOME:", R.home(), "\n")
  cat("  R_LIBS_USER:", Sys.getenv("R_LIBS_USER"), "\n")
  cat("  R_LIBS_SITE:", Sys.getenv("R_LIBS_SITE"), "\n")
  
  return(env_info)
}

# ============================================================================
# 16. COMPREHENSIVE PACKAGE AUDIT
# ============================================================================

comprehensive_package_audit <- function() {
  cat("\n\n16. COMPREHENSIVE PACKAGE AUDIT\n")
  cat("-------------------------------------------\n")
  
  # All R packages categorized
  all_packages <- installed.packages()
  
  # Categorize packages
  spatial_packages <- all_packages[grepl("sf|terra|stars|raster|sp|rgdal|maptools|leaflet|tmap", 
                                        rownames(all_packages), ignore.case = TRUE), ]
  ml_packages <- all_packages[grepl("tensorflow|keras|torch|caret|randomForest|xgboost|mlr|h2o", 
                                   rownames(all_packages), ignore.case = TRUE), ]
  viz_packages <- all_packages[grepl("ggplot|plotly|shiny|htmlwidgets|rayshader|rgl", 
                                    rownames(all_packages), ignore.case = TRUE), ]
  data_packages <- all_packages[grepl("dplyr|data.table|arrow|DBI|odbc|RSQLite", 
                                     rownames(all_packages), ignore.case = TRUE), ]
  
  cat("R PACKAGE CATEGORIES:\n")
  cat("  Spatial Analysis (", nrow(spatial_packages), " packages):\n")
  if(nrow(spatial_packages) > 0) {
    for(i in 1:min(10, nrow(spatial_packages))) {
      cat("    ", rownames(spatial_packages)[i], " (", spatial_packages[i, "Version"], ")\n")
    }
    if(nrow(spatial_packages) > 10) cat("    ... and", nrow(spatial_packages) - 10, "more\n")
  }
  
  cat("  Machine Learning (", nrow(ml_packages), " packages):\n")
  if(nrow(ml_packages) > 0) {
    for(i in 1:min(10, nrow(ml_packages))) {
      cat("    ", rownames(ml_packages)[i], " (", ml_packages[i, "Version"], ")\n")
    }
    if(nrow(ml_packages) > 10) cat("    ... and", nrow(ml_packages) - 10, "more\n")
  }
  
  cat("  Visualization (", nrow(viz_packages), " packages):\n")
  if(nrow(viz_packages) > 0) {
    for(i in 1:min(10, nrow(viz_packages))) {
      cat("    ", rownames(viz_packages)[i], " (", viz_packages[i, "Version"], ")\n")
    }
    if(nrow(viz_packages) > 10) cat("    ... and", nrow(viz_packages) - 10, "more\n")
  }
  
  cat("  Data Processing (", nrow(data_packages), " packages):\n")
  if(nrow(data_packages) > 0) {
    for(i in 1:min(10, nrow(data_packages))) {
      cat("    ", rownames(data_packages)[i], " (", data_packages[i, "Version"], ")\n")
    }
    if(nrow(data_packages) > 10) cat("    ... and", nrow(data_packages) - 10, "more\n")
  }
  
  return(list(
    spatial = spatial_packages,
    ml = ml_packages,
    viz = viz_packages,
    data = data_packages
  ))
}

# ============================================================================
# 17. SYSTEM PERFORMANCE BENCHMARKS
# ============================================================================

run_performance_benchmarks <- function() {
  cat("\n\n17. SYSTEM PERFORMANCE BENCHMARKS\n")
  cat("-------------------------------------------\n")
  
  bench_results <- list()
  
  # CPU Benchmark
  cat("Running CPU benchmark...\n")
  cpu_start <- Sys.time()
  result <- sum(sqrt(1:1000000))
  cpu_end <- Sys.time()
  cpu_time <- as.numeric(difftime(cpu_end, cpu_start, units = "secs"))
  cat("  CPU Test (1M sqrt operations):", round(cpu_time, 3), "seconds\n")
  bench_results$cpu_time <- cpu_time
  
  # Memory Benchmark
  cat("Running memory benchmark...\n")
  mem_start <- Sys.time()
  large_matrix <- matrix(rnorm(10000), nrow = 100)
  result_matrix <- large_matrix %*% t(large_matrix)
  mem_end <- Sys.time()
  mem_time <- as.numeric(difftime(mem_end, mem_start, units = "secs"))
  cat("  Memory Test (100x100 matrix multiplication):", round(mem_time, 3), "seconds\n")
  bench_results$memory_time <- mem_time
  
  # Parallel Processing Benchmark
  if(require(parallel, quietly = TRUE)) {
    cat("Running parallel processing benchmark...\n")
    parallel_start <- Sys.time()
    cl <- makeCluster(min(4, detectCores()))
    result_parallel <- parSapply(cl, 1:10000, function(x) sqrt(x))
    stopCluster(cl)
    parallel_end <- Sys.time()
    parallel_time <- as.numeric(difftime(parallel_end, parallel_start, units = "secs"))
    cat("  Parallel Test (10K sqrt operations on", min(4, detectCores()), "cores):", round(parallel_time, 3), "seconds\n")
    bench_results$parallel_time <- parallel_time
  }
  
  # Disk I/O Benchmark
  cat("Running disk I/O benchmark...\n")
  temp_file <- file.path(tempdir(), "benchmark_test.csv")
  io_start <- Sys.time()
  test_data <- data.frame(x = rnorm(100000), y = rnorm(100000))
  write.csv(test_data, temp_file)
  read_data <- read.csv(temp_file)
  file.remove(temp_file)
  io_end <- Sys.time()
  io_time <- as.numeric(difftime(io_end, io_start, units = "secs"))
  cat("  Disk I/O Test (100K rows write/read):", round(io_time, 3), "seconds\n")
  bench_results$io_time <- io_time
  
  return(bench_results)
}

# ============================================================================
# ENHANCED MAIN EXECUTION
# ============================================================================

main <- function() {
  cat("Starting COMPREHENSIVE system check and environment analysis...\n\n")
  
  # Run all detection functions
  r_info <- detect_r_environment()
  python_paths <- detect_python_environment() 
  ide_info <- detect_ides()
  gpu_info <- detect_cuda_gpu()
  db_info <- detect_databases()
  geo_info <- detect_geospatial_libs()
  llm_info <- detect_llm_tools()
  
  # Additional comprehensive checks
  lang_info <- detect_all_programming_environments()
  container_info <- detect_containerization()
  cloud_info <- detect_cloud_tools()
  vcs_info <- detect_version_control()
  sys_specs <- detect_system_specs()
  env_info <- detect_environment_variables()
  package_audit <- comprehensive_package_audit()
  
  # Performance benchmarks
  cat("\n" %+% "=" %+% rep("=", 65) %+% "\n")
  cat("RUNNING PERFORMANCE BENCHMARKS (This may take a few minutes...)\n")
  cat("=" %+% rep("=", 65) %+% "\n")
  bench_results <- run_performance_benchmarks()
  
  # Setup project structure
  config_path <- setup_project_structure()
  
  # Generate comprehensive final report
  report_path <- generate_comprehensive_system_report(
    r_info, python_paths, ide_info, gpu_info, db_info, geo_info, llm_info,
    lang_info, container_info, cloud_info, vcs_info, sys_specs, env_info,
    package_audit, bench_results
  )
  
  cat("\n=================================================================\n")
  cat("COMPREHENSIVE SYSTEM CHECK COMPLETE!\n")
  cat("=================================================================\n")
  cat("Analysis Results:\n")
  cat("✓ Detected", length(python_paths), "Python installation(s)\n")
  cat("✓ Found", nrow(installed.packages()), "R packages installed\n")
  cat("✓ GPU Support:", ifelse(gpu_info$nvidia_gpu, "Available", "Not detected"), "\n")
  cat("✓ Container Support:", ifelse(!is.null(container_info$docker), "Docker Available", "Limited"), "\n")
  cat("✓ Cloud CLI Tools:", length(cloud_info), "detected\n")
  cat("✓ Performance Score: CPU(", round(bench_results$cpu_time, 2), "s), Memory(", round(bench_results$memory_time, 2), "s)\n")
  
  cat("\nGenerated Files:\n")
  cat("📄 Comprehensive Report:", report_path, "\n")
  cat("📁 Project Structure:", PROJECT_ROOT, "\n")
  cat("⚙️  Configuration Files:", config_path, "\n")
  
  cat("\nRecommended Next Steps:\n")
  cat("1. Review the comprehensive report for detailed analysis\n")
  cat("2. Install any missing critical components\n")
  cat("3. Configure environment variables and API keys\n")
  cat("4. Test performance with sample datasets\n")
  cat("5. Begin ORAIL CITIZEN AI implementation\n\n")
  
  cat("Quick Start Commands:\n")
  cat("setwd('", PROJECT_ROOT, "')\n")
  cat("source('config/r_environment.R')\n")
  cat("# Load essential libraries and begin analysis\n\n")
  
  # Return comprehensive results
  return(list(
    r_info = r_info,
    python_paths = python_paths,
    ide_info = ide_info,
    gpu_info = gpu_info,
    performance = bench_results,
    project_path = PROJECT_ROOT,
    report_path = report_path
  ))
}

# ============================================================================
# ENHANCED REPORT GENERATION
# ============================================================================

generate_comprehensive_system_report <- function(r_info, python_paths, ide_info, gpu_info, db_info, geo_info, llm_info,
                                                lang_info, container_info, cloud_info, vcs_info, sys_specs, env_info,
                                                package_audit, bench_results) {
  
  # Create comprehensive report
  report_content <- paste0(
    "# ORAIL CITIZEN AI - Comprehensive System Environment Report\n",
    "Generated: ", Sys.time(), "\n",
    "User: ", Sys.getenv("USERNAME"), "\n",
    "Computer: ", Sys.getenv("COMPUTERNAME"), "\n",
    "Project Root: ", PROJECT_ROOT, "\n\n",
    
    "## Executive Summary\n",
    "This comprehensive system analysis detected:\n",
    "- R Environment: ", r_info$version, "\n",
    "- Python Installations: ", length(python_paths), "\n",
    "- Development Tools: ", length(ide_info), " IDEs detected\n",
    "- GPU Support: ", ifelse(gpu_info$nvidia_gpu, "NVIDIA GPU Available", "CPU Only"), "\n",
    "- Container Support: ", ifelse(!is.null(container_info$docker), "Docker Available", "Not Available"), "\n",
    "- Total R Packages: ", r_info$installed_packages, "\n\n",
    
    "## Performance Benchmarks\n",
    "- CPU Performance: ", round(bench_results$cpu_time, 3), " seconds (1M operations)\n",
    "- Memory Performance: ", round(bench_results$memory_time, 3), " seconds (matrix operations)\n",
    "- Disk I/O Performance: ", round(bench_results$io_time, 3), " seconds (100K rows)\n"
  )
  
  if(!is.null(bench_results$parallel_time)) {
    report_content <- paste0(report_content,
      "- Parallel Processing: ", round(bench_results$parallel_time, 3), " seconds (4 cores)\n"
    )
  }
  
  report_content <- paste0(report_content, "\n## Detailed Analysis\n\n")
  
  # Add all sections...
  report_content <- paste0(report_content,
    "### R Environment\n",
    "- Version: ", r_info$version, "\n",
    "- Home Directory: ", r_info$home, "\n",
    "- Platform: ", r_info$platform, "\n",
    "- Architecture: ", r_info$arch, "\n",
    "- Library Paths: ", length(r_info$library_paths), " configured\n",
    "- Installed Packages: ", r_info$installed_packages, "\n\n"
  )
  
  # Continue building the comprehensive report...
  # (Additional sections would be added here for each category)
  
  # Save report
  report_path <- file.path(PROJECT_ROOT, "docs", "comprehensive_system_report.md")
  writeLines(report_content, report_path)
  
  # Also create a summary JSON for programmatic access
  summary_json <- list(
    timestamp = Sys.time(),
    user = Sys.getenv("USERNAME"),
    project_root = PROJECT_ROOT,
    r_version = r_info$version,
    python_count = length(python_paths),
    gpu_available = gpu_info$nvidia_gpu,
    docker_available = !is.null(container_info$docker),
    performance = bench_results,
    package_counts = list(
      r_total = r_info$installed_packages,
      spatial = ifelse(is.null(package_audit$spatial), 0, nrow(package_audit$spatial)),
      ml = ifelse(is.null(package_audit$ml), 0, nrow(package_audit$ml)),
      viz = ifelse(is.null(package_audit$viz), 0, nrow(package_audit$viz))
    )
  )
  
  summary_path <- file.path(PROJECT_ROOT, "config", "system_summary.json")
  writeLines(jsonlite::toJSON(summary_json, pretty = TRUE), summary_path)
  
  cat("Comprehensive report saved to:", report_path, "\n")
  cat("Summary JSON saved to:", summary_path, "\n")
  
  return(report_path)
}

# Run the enhanced main function
main()
