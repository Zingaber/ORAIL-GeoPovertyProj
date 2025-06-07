#!/usr/bin/env python3
"""
ORAIL CITIZEN AI - Cursor IDE Setup Script
Geospatial Poverty Mapping Framework

Clean version without emoji for classic code format
Author: Joseph V Thomas (ORAIL)
License: Creative Commons
"""

import os
import sys
import json
import subprocess
from pathlib import Path


# Configuration class using existing installations
class ORailConfig:
    PROJECT_ROOT = "C:/Users/josze/MYRworkspace-CitizenAI-poverty-mapping"
    PYTHON_EXE = "C:/Users/josze/anaconda3/User-quantuM-CDAC-CLASS/anaconda3/python.exe"
    CONDA_ROOT = "C:/Users/josze/anaconda3/User-quantuM-CDAC-CLASS/anaconda3"

    # Existing environments
    BASE_ENV = "base"
    QISKIT_ENV = "qiskit-env"
    THELLMBOOK_ENV = "thellmbook"

    # Package versions from system scan
    TENSORFLOW_VERSION = "2.19.0"
    PYTORCH_VERSION = "2.5.1"
    NUMPY_VERSION = "1.26.4"
    PANDAS_VERSION = "2.2.2"

    # GPU info
    GPU_NAME = "NVIDIA GeForce RTX 4070 Laptop GPU"


def create_directory_structure():
    """Create project directory structure"""
    print("Creating project directory structure...")

    # Ensure main project directory exists
    Path(ORailConfig.PROJECT_ROOT).mkdir(parents=True, exist_ok=True)

    # Define subdirectories
    directories = [
        "data/raw/satellite",
        "data/raw/census",
        "data/raw/osm",
        "data/raw/mobile",
        "data/processed/cleaned",
        "data/processed/features",
        "data/cache/temp",
        "data/cache/downloads",
        "models/trained/ensemble",
        "models/trained/cnn",
        "models/trained/xgboost",
        "models/configs",
        "outputs/maps/2d",
        "outputs/maps/3d",
        "outputs/reports/html",
        "outputs/reports/pdf",
        "outputs/visualizations/interactive",
        "outputs/visualizations/static",
        "scripts/python/ml",
        "scripts/python/data_processing",
        "scripts/python/llm_integration",
        "scripts/r/analysis",
        "scripts/r/visualization",
        "scripts/sql",
        "config/environments",
        "config/api_keys",
        "logs/processing",
        "logs/models",
        "temp/downloads",
        "temp/processing",
        "docs/reports",
        "docs/methodology",
        "notebooks/exploratory",
        "notebooks/modeling",
        "notebooks/visualization",
        ".github/workflows",
        ".vscode",
        "environments",
    ]

    # Create all subdirectories
    for directory in directories:
        dir_path = Path(ORailConfig.PROJECT_ROOT) / directory
        dir_path.mkdir(parents=True, exist_ok=True)

    print(f"Created {len(directories)} subdirectories")
    return ORailConfig.PROJECT_ROOT


def check_existing_packages():
    """Check existing Python packages from system scan"""
    print("Checking existing packages...")

    # Known installed packages from system scan
    installed_packages = {
        "numpy": "1.26.4",
        "pandas": "2.2.2",
        "matplotlib": "3.9.2",
        "tensorflow": "2.19.0",
        "torch": "2.5.1",
        "scikit-learn": "1.5.1",
        "jupyter": "1.0.0",
        "plotly": "5.24.1",
        "seaborn": "0.13.2",
        "requests": "2.32.3",
        "streamlit": "1.37.1",
    }

    print("Installed packages:")
    for package, version in installed_packages.items():
        print(f"  {package}: {version}")

    # Check for missing geospatial packages
    missing_packages = [
        "geopandas",
        "rasterio",
        "shapely",
        "fiona",
        "folium",
        "contextily",
        "xarray",
        "netcdf4",
        "openai",
        "anthropic",
        "langchain",
        "python-dotenv",
    ]

    print("\nChecking geospatial and AI packages:")
    for package in missing_packages:
        try:
            __import__(package)
            print(f"  {package}: Available")
        except ImportError:
            print(f"  {package}: Not installed")

    return installed_packages


def install_missing_packages():
    """Install missing packages for geospatial analysis"""
    print("Installing missing packages...")

    packages_to_install = [
        "geopandas",
        "rasterio",
        "shapely",
        "fiona",
        "folium",
        "contextily",
        "xarray",
        "netcdf4",
        "openai",
        "langchain",
        "python-dotenv",
        "pyproj",
        "cartopy",
    ]

    for package in packages_to_install:
        try:
            print(f"Installing {package}...")
            subprocess.run(
                [ORailConfig.PYTHON_EXE, "-m", "pip", "install", package],
                check=True,
                capture_output=True,
                text=True,
            )
            print(f"  {package} installed successfully")
        except subprocess.CalledProcessError as e:
            print(f"  {package} installation failed: {e}")

    print("Package installation complete")


def create_environment_config():
    """Create environment configuration file"""
    print("Creating environment configuration...")

    env_content = f"""# ORAIL CITIZEN AI - Environment Configuration
# Generated for Cursor IDE

import os
import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import warnings
warnings.filterwarnings('ignore')

# Project configuration
PROJECT_ROOT = '{ORailConfig.PROJECT_ROOT}'
DATA_ROOT = os.path.join(PROJECT_ROOT, 'data')
MODELS_ROOT = os.path.join(PROJECT_ROOT, 'models')
OUTPUTS_ROOT = os.path.join(PROJECT_ROOT, 'outputs')

# Add project to Python path
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

# Set working directory
os.chdir(PROJECT_ROOT)

# GPU configuration
try:
    import torch
    import tensorflow as tf
    
    # PyTorch GPU setup
    if torch.cuda.is_available():
        device = torch.device('cuda')
        print(f'GPU: {{torch.cuda.get_device_name(0)}}')
        print(f'CUDA version: {{torch.version.cuda}}')
    else:
        device = torch.device('cpu')
        print('Using CPU for PyTorch')
    
    # TensorFlow GPU setup
    gpus = tf.config.experimental.list_physical_devices('GPU')
    if gpus:
        try:
            for gpu in gpus:
                tf.config.experimental.set_memory_growth(gpu, True)
            print(f'TensorFlow GPU: {{len(gpus)}} device(s) available')
        except RuntimeError as e:
            print(f'GPU config error: {{e}}')
    
except ImportError as e:
    print(f'GPU libraries not available: {{e}}')
    device = 'cpu'

# Configure matplotlib for better plots
plt.style.use('default')
plt.rcParams['figure.figsize'] = (12, 8)
plt.rcParams['font.size'] = 10

print('ORAIL CITIZEN AI Environment Loaded')
print(f'Project root: {{PROJECT_ROOT}}')
print(f'Python: {{sys.version.split()[0]}}')
print(f'NumPy: {{np.__version__}}')
print(f'Pandas: {{pd.__version__}}')
"""

    env_path = os.path.join(ORailConfig.PROJECT_ROOT, "config", "environment.py")
    with open(env_path, "w", encoding="utf-8") as f:
        f.write(env_content)

    print(f"Created environment.py: {env_path}")
    return env_path


def create_cursor_workspace():
    """Create Cursor workspace configuration"""
    print("Creating Cursor workspace configuration...")

    workspace_config = {
        "folders": [{"path": ORailConfig.PROJECT_ROOT}],
        "settings": {
            "python.defaultInterpreterPath": ORailConfig.PYTHON_EXE,
            "python.condaPath": os.path.join(
                ORailConfig.CONDA_ROOT, "Scripts", "conda.exe"
            ),
            "jupyter.jupyterServerType": "local",
            "jupyter.notebookFileRoot": os.path.join(
                ORailConfig.PROJECT_ROOT, "notebooks"
            ),
            "files.watcherExclude": {
                "**/temp/**": True,
                "**/data/cache/**": True,
                "**/__pycache__/**": True,
            },
            "python.analysis.autoImportCompletions": True,
            "python.analysis.typeCheckingMode": "basic",
            "editor.formatOnSave": True,
            "python.formatting.provider": "black",
            "terminal.integrated.cwd": ORailConfig.PROJECT_ROOT,
        },
        "extensions": {
            "recommendations": [
                "ms-python.python",
                "ms-python.vscode-pylance",
                "ms-toolsai.jupyter",
                "ms-python.black-formatter",
                "ms-vscode.vscode-json",
                "redhat.vscode-yaml",
            ]
        },
    }

    workspace_path = os.path.join(
        ORailConfig.PROJECT_ROOT, "orail-citizenai.code-workspace"
    )
    with open(workspace_path, "w", encoding="utf-8") as f:
        json.dump(workspace_config, f, indent=2)

    print(f"Created Cursor workspace: {workspace_path}")
    return workspace_path


def create_cursor_settings():
    """Create Cursor-specific settings"""
    print("Creating Cursor IDE settings...")

    cursor_settings = {
        "python.defaultInterpreterPath": ORailConfig.PYTHON_EXE,
        "python.condaPath": os.path.join(
            ORailConfig.CONDA_ROOT, "Scripts", "conda.exe"
        ),
        "jupyter.jupyterServerType": "local",
        "jupyter.notebookFileRoot": os.path.join(ORailConfig.PROJECT_ROOT, "notebooks"),
        "terminal.integrated.defaultProfile.windows": "Command Prompt",
        "terminal.integrated.cwd": ORailConfig.PROJECT_ROOT,
        "files.autoSave": "afterDelay",
        "files.autoSaveDelay": 1000,
        "editor.minimap.enabled": True,
        "editor.lineNumbers": "on",
        "editor.rulers": [80, 120],
        "python.linting.enabled": True,
        "python.linting.pylintEnabled": True,
        "python.analysis.autoImportCompletions": True,
        "git.enableSmartCommit": True,
        "git.confirmSync": False,
    }

    settings_dir = os.path.join(ORailConfig.PROJECT_ROOT, ".vscode")
    settings_path = os.path.join(settings_dir, "settings.json")

    with open(settings_path, "w", encoding="utf-8") as f:
        json.dump(cursor_settings, f, indent=2)

    print(f"Created Cursor settings: {settings_path}")
    return settings_path


def create_starter_notebook():
    """Create initial Jupyter notebook"""
    print("Creating starter notebook...")

    notebook_content = {
        "cells": [
            {
                "cell_type": "markdown",
                "metadata": {},
                "source": [
                    "# ORAIL CITIZEN AI - Geospatial Poverty Mapping\\n",
                    "\\n",
                    "## Getting Started with Cursor IDE\\n",
                    "\\n",
                    "This notebook demonstrates the ORAIL CITIZEN AI framework using existing installations:\\n",
                    "- Python 3.12.3 (Anaconda)\\n",
                    "- TensorFlow 2.19.0\\n",
                    "- PyTorch 2.5.1\\n",
                    "- NVIDIA RTX 4070 GPU\\n",
                    "\\n",
                    "**Project Directory:** C:/Users/josze/MYRworkspace-CitizenAI-poverty-mapping",
                ],
            },
            {
                "cell_type": "code",
                "execution_count": None,
                "metadata": {},
                "source": [
                    "# Load ORAIL CITIZEN AI environment\\n",
                    "exec(open('../config/environment.py').read())",
                ],
            },
            {
                "cell_type": "code",
                "execution_count": None,
                "metadata": {},
                "source": [
                    "# System check\\n",
                    "print('System Check:')\\n",
                    "print(f'  Working directory: {os.getcwd()}')\\n",
                    "print(f'  Python executable: {sys.executable}')\\n",
                    "print(f'  Available device: {device}')\\n",
                    "print(f'  NumPy version: {np.__version__}')\\n",
                    "print(f'  Pandas version: {pd.__version__}')",
                ],
            },
            {
                "cell_type": "code",
                "execution_count": None,
                "metadata": {},
                "source": [
                    "# Create sample poverty data\\n",
                    "print('Creating sample poverty mapping data...')\\n",
                    "\\n",
                    "# Generate sample data for poverty mapping\\n",
                    "n_locations = 1000\\n",
                    "sample_data = pd.DataFrame({\\n",
                    "    'latitude': np.random.uniform(14.0, 15.0, n_locations),\\n",
                    "    'longitude': np.random.uniform(120.0, 121.0, n_locations),\\n",
                    "    'poverty_rate': np.random.beta(2, 5, n_locations),\\n",
                    "    'population': np.random.randint(100, 10000, n_locations),\\n",
                    "    'education_index': np.random.uniform(0.3, 0.9, n_locations),\\n",
                    "    'health_index': np.random.uniform(0.4, 0.95, n_locations),\\n",
                    "    'infrastructure_index': np.random.uniform(0.2, 0.8, n_locations)\\n",
                    "})\\n",
                    "\\n",
                    "print(f'Created dataset with {len(sample_data)} locations')\\n",
                    "sample_data.head()",
                ],
            },
            {
                "cell_type": "code",
                "execution_count": None,
                "metadata": {},
                "source": [
                    "# Basic poverty analysis\\n",
                    "print('Basic Poverty Analysis:')\\n",
                    "print(f'  Average poverty rate: {sample_data[\\\"poverty_rate\\\"].mean():.3f}')\\n",
                    'print(f\'  Poverty rate range: {sample_data[\\"poverty_rate\\"].min():.3f} - {sample_data[\\"poverty_rate\\"].max():.3f}\')\\n',
                    "print(f'  High poverty areas (>0.3): {(sample_data[\\\"poverty_rate\\\"] > 0.3).sum()}')\\n",
                    "\\n",
                    "# Create basic visualization\\n",
                    "plt.figure(figsize=(12, 8))\\n",
                    "scatter = plt.scatter(sample_data['longitude'], sample_data['latitude'], \\n",
                    "                     c=sample_data['poverty_rate'], cmap='Reds', \\n",
                    "                     alpha=0.6, s=30)\\n",
                    "plt.colorbar(scatter, label='Poverty Rate')\\n",
                    "plt.xlabel('Longitude')\\n",
                    "plt.ylabel('Latitude')\\n",
                    "plt.title('ORAIL CITIZEN AI - Sample Poverty Distribution Map')\\n",
                    "plt.grid(True, alpha=0.3)\\n",
                    "plt.show()\\n",
                    "\\n",
                    "print('Basic analysis complete')",
                ],
            },
            {
                "cell_type": "markdown",
                "metadata": {},
                "source": [
                    "## Next Steps\\n",
                    "\\n",
                    "1. **Explore Data**: Load real satellite imagery and census data\\n",
                    "2. **Feature Engineering**: Extract geospatial features for ML models\\n",
                    "3. **Model Training**: Train poverty prediction models using TensorFlow/PyTorch\\n",
                    "4. **3D Visualization**: Create 3D poverty surface maps\\n",
                    "5. **LLM Integration**: Add natural language insights and explanations\\n",
                    "\\n",
                    "## Useful Commands for Cursor IDE\\n",
                    "\\n",
                    "- **Ctrl+Shift+P**: Command palette\\n",
                    "- **Ctrl+`**: Open terminal\\n",
                    "- **Shift+Enter**: Run code cell\\n",
                    "- **Ctrl+Shift+L**: Format code\\n",
                    "- **F12**: Go to definition",
                ],
            },
        ],
        "metadata": {
            "kernelspec": {
                "display_name": "Python 3",
                "language": "python",
                "name": "python3",
            },
            "language_info": {"name": "python", "version": "3.12.3"},
        },
        "nbformat": 4,
        "nbformat_minor": 4,
    }

    notebook_path = os.path.join(
        ORailConfig.PROJECT_ROOT, "notebooks", "01_orail_getting_started.ipynb"
    )
    with open(notebook_path, "w", encoding="utf-8") as f:
        json.dump(notebook_content, f, indent=2)

    print(f"Created starter notebook: {notebook_path}")
    return notebook_path


def create_project_readme():
    """Create project README"""
    print("Creating project README...")

    readme_content = f"""# ORAIL CITIZEN AI - Geospatial Poverty Mapping Framework

**Open Source Responsible AI Literacy (ORAIL) Initiative**

## Project Overview

The ORAIL CITIZEN AI framework provides advanced geospatial poverty mapping capabilities using AI, machine learning, and satellite imagery analysis.

## System Configuration

- **Project Directory**: {ORailConfig.PROJECT_ROOT}
- **Python**: 3.12.3 (Anaconda)
- **GPU**: {ORailConfig.GPU_NAME}
- **TensorFlow**: {ORailConfig.TENSORFLOW_VERSION}
- **PyTorch**: {ORailConfig.PYTORCH_VERSION}
- **IDE**: Cursor IDE

## Quick Start with Cursor IDE

### 1. Open Project in Cursor
```bash
cd "{ORailConfig.PROJECT_ROOT}"
cursor .
```

### 2. Load Environment
```python
# In any Python file or notebook
exec(open('config/environment.py').read())
```

### 3. Start Jupyter Notebook
```bash
jupyter lab
```

### 4. Run Starter Script
```bash
python scripts/python/starter_analysis.py
```

## Project Structure

```
{ORailConfig.PROJECT_ROOT}/
├── data/
│   ├── raw/          # Raw satellite, census data
│   ├── processed/    # Cleaned datasets
│   └── cache/        # Temporary files
├── models/           # Trained ML models
├── outputs/          # Maps, reports, visualizations
├── scripts/          # Analysis scripts
├── notebooks/        # Jupyter notebooks
├── config/           # Configuration files
└── .vscode/          # Cursor IDE settings
```

## Development Workflow

1. **Data Collection**: Satellite imagery, census data, mobile data
2. **Feature Engineering**: Extract poverty indicators
3. **Model Training**: AI/ML poverty prediction models
4. **3D Visualization**: Interactive poverty maps
5. **LLM Integration**: Natural language insights

## Key Features

- Real-time poverty monitoring
- 3D geospatial visualization
- AI-powered analytics
- Multi-source data integration
- GPU acceleration support
- LLM-enhanced insights

## Contact

- **Author**: Joseph V Thomas
- **Organization**: ORAIL (Open Source Responsible AI Literacy)
- **Email**: citizen-ai@orail.org
- **License**: Creative Commons

## Getting Help

1. Check notebooks in `notebooks/` folder
2. Review configuration in `config/` folder  
3. Explore examples in `scripts/` folder
4. Open issues on project repository

Ready to map poverty with AI!
"""

    readme_path = os.path.join(ORailConfig.PROJECT_ROOT, "README.md")
    with open(readme_path, "w", encoding="utf-8") as f:
        f.write(readme_content)

    print(f"Created README.md: {readme_path}")
    return readme_path


def create_activation_scripts():
    """Create environment activation scripts"""
    print("Creating activation scripts...")

    # Windows batch script
    batch_script = f"""@echo off
echo ORAIL CITIZEN AI - Environment Activation
echo ========================================
echo Activating conda environment and setting up project...

cd /d "{ORailConfig.PROJECT_ROOT}"
call conda activate base

echo.
echo Environment activated
echo Project directory: %CD%
echo.
echo Available commands:
echo   jupyter lab          - Start Jupyter Lab
echo   python --version     - Check Python version
echo.
echo To start development:
echo   1. jupyter lab       (for notebooks)
echo   2. code .            (for VS Code)
echo   3. cursor .          (for Cursor IDE)
echo.

cmd /k
"""

    batch_path = os.path.join(ORailConfig.PROJECT_ROOT, "activate_orail_env.bat")
    with open(batch_path, "w", encoding="utf-8") as f:
        f.write(batch_script)

    print(f"Created activation script: {batch_path}")
    return batch_path


def main():
    """Main execution function"""

    print("ORAIL CITIZEN AI - Cursor IDE Setup")
    print("=" * 50)
    print(f"Setting up project in: {ORailConfig.PROJECT_ROOT}")
    print("Using existing installations from system scan")
    print()

    try:
        # Create project directory structure
        print("Step 1: Creating project structure...")
        project_root = create_directory_structure()
        print(f"Project directory created: {project_root}")

        # Check existing packages
        print("\nStep 2: Checking existing packages...")
        installed_packages = check_existing_packages()

        # Install missing packages
        print("\nStep 3: Installing missing packages...")
        install_missing_packages()

        # Create environment configuration
        print("\nStep 4: Creating environment config...")
        env_path = create_environment_config()

        # Setup Cursor IDE integration
        print("\nStep 5: Setting up Cursor IDE...")
        workspace_path = create_cursor_workspace()
        settings_path = create_cursor_settings()

        # Create project files
        print("\nStep 6: Creating project files...")
        notebook_path = create_starter_notebook()
        readme_path = create_project_readme()
        activation_path = create_activation_scripts()

        # Final summary
        print("\n" + "=" * 50)
        print("ORAIL CITIZEN AI SETUP COMPLETE")
        print("=" * 50)

        print(f"\nProject Location:")
        print(f"  {project_root}")

        print(f"\nOpen in Cursor IDE:")
        print(f'  cursor "{workspace_path}"')

        print(f"\nStart with Jupyter:")
        print(f"  jupyter lab")

        print(f"\nKey Files Created:")
        print(f"  Workspace: {workspace_path}")
        print(f"  Settings: {settings_path}")
        print(f"  Environment: {env_path}")
        print(f"  Notebook: {notebook_path}")
        print(f"  README: {readme_path}")
        print(f"  Activation: {activation_path}")

        print(f"\nNext Steps:")
        print(f'  1. Open Cursor: cursor "{project_root}"')
        print(f"  2. Load environment: exec(open('config/environment.py').read())")
        print(f"  3. Open notebook: notebooks/01_orail_getting_started.ipynb")
        print(f"  4. Start developing")

        return True

    except Exception as e:
        print(f"\nSetup failed: {e}")
        print(f"Error details: {type(e).__name__}")
        return False


if __name__ == "__main__":
    success = main()
    if success:
        print("\nReady for ORAIL CITIZEN AI development in Cursor IDE")
    else:
        print("\nSetup encountered errors. Please check the messages above.")
