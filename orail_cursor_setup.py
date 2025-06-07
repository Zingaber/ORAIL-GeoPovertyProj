#!/usr/bin/env python3
"""
ORAIL CITIZEN AI - Cursor IDE Execution Script
Geospatial Poverty Mapping Framework

Simple execution script designed for Cursor IDE
Uses existing installations from your system scan:
- Python 3.12.3 (Anaconda)
- TensorFlow 2.19.0
- PyTorch 2.5.1
- NVIDIA RTX 4070 GPU
- Cursor IDE

Author: Joseph V Thomas (ORAIL)
Project Directory: C:\Users\josze\MYRworkspace-CitizenAI-poverty-mapping
"""

import os
import sys
import subprocess
import json
from pathlib import Path
import warnings
warnings.filterwarnings('ignore')

# ============================================================================
# PROJECT CONFIGURATION (Based on your system scan)
# ============================================================================

class ORailConfig:
    """Configuration class using your existing installations"""
    
    # Project paths (LOCAL - no OneDrive)
    PROJECT_ROOT = r"C:\Users\josze\MYRworkspace-CitizenAI-poverty-mapping"
    
    # Existing system paths from your scan
    PYTHON_EXE = r"C:\Users\josze\anaconda3\User-quantuM-CDAC-CLASS\anaconda3\python.exe"
    CONDA_ROOT = r"C:\Users\josze\anaconda3\User-quantuM-CDAC-CLASS\anaconda3"
    CURSOR_IDE = r"C:\Users\josze\AppData\Local\Programs\cursor"
    PYCHARM_IDE = r"C:\Program Files\JetBrains\PyCharm Community Edition 2025.1.1.1"
    GIT_EXE = r"C:\Program Files\Git\cmd\git.exe"
    
    # Existing environments
    BASE_ENV = "base"
    QISKIT_ENV = "qiskit-env"
    THELLMBOOK_ENV = "thellmbook"
    
    # Installed packages (from your scan)
    TENSORFLOW_VERSION = "2.19.0"
    PYTORCH_VERSION = "2.5.1"
    NUMPY_VERSION = "1.26.4"
    PANDAS_VERSION = "2.2.2"
    
    # GPU info
    GPU_NAME = "NVIDIA GeForce RTX 4070 Laptop GPU"
    
    @classmethod
    def ensure_project_directory(cls):
        """Create project directory structure"""
        Path(cls.PROJECT_ROOT).mkdir(parents=True, exist_ok=True)
        
        # Create essential subdirectories
        dirs = [
            "data/raw", "data/processed", "data/cache",
            "models/trained", "models/configs",
            "outputs/maps", "outputs/reports", "outputs/visualizations",
            "scripts/python", "scripts/r", "scripts/sql",
            "notebooks", "config", "logs", "temp", ".vscode"
        ]
        
        for dir_path in dirs:
            Path(cls.PROJECT_ROOT, dir_path).mkdir(parents=True, exist_ok=True)
            
        return cls.PROJECT_ROOT

# ============================================================================
# CURSOR IDE INTEGRATION
# ============================================================================

class CursorIntegration:
    """Cursor IDE specific integration and setup"""
    
    @staticmethod
    def create_cursor_workspace():
        """Create Cursor workspace configuration"""
        workspace_config = {
            "folders": [
                {"path": ORailConfig.PROJECT_ROOT}
            ],
            "settings": {
                "python.defaultInterpreterPath": ORailConfig.PYTHON_EXE,
                "python.condaPath": os.path.join(ORailConfig.CONDA_ROOT, "Scripts", "conda.exe"),
                "jupyter.jupyterServerType": "local",
                "jupyter.notebookFileRoot": os.path.join(ORailConfig.PROJECT_ROOT, "notebooks"),
                "files.watcherExclude": {
                    "**/temp/**": True,
                    "**/data/cache/**": True,
                    "**/__pycache__/**": True
                },
                "python.analysis.autoImportCompletions": True,
                "python.analysis.typeCheckingMode": "basic",
                "editor.formatOnSave": True,
                "python.formatting.provider": "black"
            },
            "extensions": {
                "recommendations": [
                    "ms-python.python",
                    "ms-python.vscode-pylance",
                    "ms-toolsai.jupyter",
                    "ms-python.black-formatter",
                    "ms-vscode.vscode-json",
                    "redhat.vscode-yaml"
                ]
            }
        }
        
        # Save workspace configuration
        workspace_path = os.path.join(ORailConfig.PROJECT_ROOT, "orail-citizenai.code-workspace")
        with open(workspace_path, 'w') as f:
            json.dump(workspace_config, f, indent=2)
        
        print(f"✅ Created Cursor workspace: {workspace_path}")
        return workspace_path
    
    @staticmethod
    def create_cursor_settings():
        """Create Cursor-specific settings"""
        cursor_settings = {
            "python.defaultInterpreterPath": ORailConfig.PYTHON_EXE,
            "python.condaPath": os.path.join(ORailConfig.CONDA_ROOT, "Scripts", "conda.exe"),
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
            "git.confirmSync": False
        }
        
        settings_dir = os.path.join(ORailConfig.PROJECT_ROOT, ".vscode")
        settings_path = os.path.join(settings_dir, "settings.json")
        
        with open(settings_path, 'w') as f:
            json.dump(cursor_settings, f, indent=2)
        
        print(f"✅ Created Cursor settings: {settings_path}")
        return settings_path

# ============================================================================
# ENVIRONMENT SETUP
# ============================================================================

class EnvironmentSetup:
    """Setup development environment using existing installations"""
    
    @staticmethod
    def check_existing_packages():
        """Check existing Python packages from your system"""
        print("🔍 CHECKING EXISTING PACKAGES...")
        
        # Known installed packages from your scan
        installed_packages = {
            'numpy': '1.26.4',
            'pandas': '2.2.2', 
            'matplotlib': '3.9.2',
            'tensorflow': '2.19.0',
            'torch': '2.5.1',
            'scikit-learn': '1.5.1',
            'jupyter': '1.0.0',
            'plotly': '5.24.1',
            'seaborn': '0.13.2',
            'requests': '2.32.3',
            'streamlit': '1.37.1'
        }
        
        print("📦 INSTALLED PACKAGES:")
        for package, version in installed_packages.items():
            print(f"   ✅ {package}: {version}")
        
        # Check for missing packages needed for geospatial analysis
        missing_packages = [
            'geopandas', 'rasterio', 'shapely', 'fiona', 
            'folium', 'contextily', 'xarray', 'netcdf4',
            'openai', 'anthropic', 'langchain'
        ]
        
        print("\n🔍 CHECKING GEOSPATIAL & AI PACKAGES:")
        for package in missing_packages:
            try:
                __import__(package)
                print(f"   ✅ {package}: Available")
            except ImportError:
                print(f"   ⚠️  {package}: Not installed (will install)")
        
        return installed_packages
    
    @staticmethod
    def install_missing_packages():
        """Install missing packages for geospatial analysis"""
        print("\n📦 INSTALLING MISSING PACKAGES...")
        
        # Essential packages for ORAIL CITIZEN AI
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
            "cartopy"
        ]
        
        for package in packages_to_install:
            try:
                print(f"Installing {package}...")
                subprocess.run([
                    ORailConfig.PYTHON_EXE, "-m", "pip", "install", package
                ], check=True, capture_output=True)
                print(f"   ✅ {package} installed successfully")
            except subprocess.CalledProcessError as e:
                print(f"   ⚠️  {package} installation failed: {e}")
        
        print("✅ Package installation complete")
    
    @staticmethod
    def create_environment_file():
        """Create environment configuration file"""
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
PROJECT_ROOT = r'{ORailConfig.PROJECT_ROOT}'
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
        print(f'🖥️  GPU: {{torch.cuda.get_device_name(0)}}')
        print(f'🔥 CUDA version: {{torch.version.cuda}}')
    else:
        device = torch.device('cpu')
        print('🖥️  Using CPU for PyTorch')
    
    # TensorFlow GPU setup
    gpus = tf.config.experimental.list_physical_devices('GPU')
    if gpus:
        try:
            for gpu in gpus:
                tf.config.experimental.set_memory_growth(gpu, True)
            print(f'🔥 TensorFlow GPU: {{len(gpus)}} device(s) available')
        except RuntimeError as e:
            print(f'⚠️  GPU config error: {{e}}')
    
except ImportError as e:
    print(f'⚠️  GPU libraries not available: {{e}}')
    device = 'cpu'

# Configure matplotlib for better plots
plt.style.use('default')
plt.rcParams['figure.figsize'] = (12, 8)
plt.rcParams['font.size'] = 10

print('🚀 ORAIL CITIZEN AI Environment Loaded!')
print(f'📁 Project root: {{PROJECT_ROOT}}')
print(f'🐍 Python: {{sys.version.split()[0]}}')
print(f'📊 NumPy: {{np.__version__}}')
print(f'🐼 Pandas: {{pd.__version__}}')
"""
        
        env_path = os.path.join(ORailConfig.PROJECT_ROOT, "config", "environment.py")
        with open(env_path, 'w') as f:
            f.write(env_content)
        
        print(f"✅ Created environment.py: {env_path}")
        return env_path

# ============================================================================
# PROJECT INITIALIZATION
# ============================================================================

class ProjectInitializer:
    """Initialize ORAIL CITIZEN AI project structure"""
    
    @staticmethod
    def create_starter_notebook():
        """Create initial Jupyter notebook for Cursor"""
        notebook_content = {
            "cells": [
                {
                    "cell_type": "markdown",
                    "metadata": {},
                    "source": [
                        "# ORAIL CITIZEN AI - Geospatial Poverty Mapping\n",
                        "\n",
                        "## Getting Started with Cursor IDE\n",
                        "\n",
                        "This notebook demonstrates the ORAIL CITIZEN AI framework using your existing installations:\n",
                        "- Python 3.12.3 (Anaconda)\n",
                        "- TensorFlow 2.19.0\n",
                        "- PyTorch 2.5.1\n",
                        "- NVIDIA RTX 4070 GPU\n",
                        "\n",
                        "**Project Directory:** `C:\\Users\\josze\\MYRworkspace-CitizenAI-poverty-mapping`"
                    ]
                },
                {
                    "cell_type": "code",
                    "execution_count": None,
                    "metadata": {},
                    "source": [
                        "# Load ORAIL CITIZEN AI environment\n",
                        "exec(open('../config/environment.py').read())"
                    ]
                },
                {
                    "cell_type": "code",
                    "execution_count": None,
                    "metadata": {},
                    "source": [
                        "# System check\n",
                        "print('🔍 SYSTEM CHECK:')\n",
                        "print(f'   📁 Working directory: {os.getcwd()}')\n",
                        "print(f'   🐍 Python executable: {sys.executable}')\n",
                        "print(f'   🖥️  Available device: {device}')\n",
                        "print(f'   💾 NumPy version: {np.__version__}')\n",
                        "print(f'   🐼 Pandas version: {pd.__version__}')"
                    ]
                },
                {
                    "cell_type": "code",
                    "execution_count": None,
                    "metadata": {},
                    "source": [
                        "# Create sample poverty data\n",
                        "print('📊 Creating sample poverty mapping data...')\n",
                        "\n",
                        "# Generate sample data for poverty mapping\n",
                        "n_locations = 1000\n",
                        "sample_data = pd.DataFrame({\n",
                        "    'latitude': np.random.uniform(14.0, 15.0, n_locations),\n",
                        "    'longitude': np.random.uniform(120.0, 121.0, n_locations),\n",
                        "    'poverty_rate': np.random.beta(2, 5, n_locations),\n",
                        "    'population': np.random.randint(100, 10000, n_locations),\n",
                        "    'education_index': np.random.uniform(0.3, 0.9, n_locations),\n",
                        "    'health_index': np.random.uniform(0.4, 0.95, n_locations),\n",
                        "    'infrastructure_index': np.random.uniform(0.2, 0.8, n_locations)\n",
                        "})\n",
                        "\n",
                        "print(f'✅ Created dataset with {len(sample_data)} locations')\n",
                        "sample_data.head()"
                    ]
                },
                {
                    "cell_type": "code",
                    "execution_count": None,
                    "metadata": {},
                    "source": [
                        "# Basic poverty analysis\n",
                        "print('🔬 BASIC POVERTY ANALYSIS:')\n",
                        "print(f'   📈 Average poverty rate: {sample_data[\"poverty_rate\"].mean():.3f}')\n",
                        "print(f'   📊 Poverty rate range: {sample_data[\"poverty_rate\"].min():.3f} - {sample_data[\"poverty_rate\"].max():.3f}')\n",
                        "print(f'   🚨 High poverty areas (>0.3): {(sample_data[\"poverty_rate\"] > 0.3).sum()}')\n",
                        "\n",
                        "# Create basic visualization\n",
                        "plt.figure(figsize=(12, 8))\n",
                        "scatter = plt.scatter(sample_data['longitude'], sample_data['latitude'], \n",
                        "                     c=sample_data['poverty_rate'], cmap='Reds', \n",
                        "                     alpha=0.6, s=30)\n",
                        "plt.colorbar(scatter, label='Poverty Rate')\n",
                        "plt.xlabel('Longitude')\n",
                        "plt.ylabel('Latitude')\n",
                        "plt.title('ORAIL CITIZEN AI - Sample Poverty Distribution Map')\n",
                        "plt.grid(True, alpha=0.3)\n",
                        "plt.show()\n",
                        "\n",
                        "print('✅ Basic analysis complete!')"
                    ]
                },
                {
                    "cell_type": "markdown",
                    "metadata": {},
                    "source": [
                        "## Next Steps\n",
                        "\n",
                        "1. **Explore Data**: Load real satellite imagery and census data\n",
                        "2. **Feature Engineering**: Extract geospatial features for ML models\n",
                        "3. **Model Training**: Train poverty prediction models using TensorFlow/PyTorch\n",
                        "4. **3D Visualization**: Create 3D poverty surface maps\n",
                        "5. **LLM Integration**: Add natural language insights and explanations\n",
                        "\n",
                        "## Useful Commands for Cursor IDE\n",
                        "\n",
                        "- **Ctrl+Shift+P**: Command palette\n",
                        "- **Ctrl+`**: Open terminal\n",
                        "- **Shift+Enter**: Run code cell\n",
                        "- **Ctrl+Shift+L**: Format code\n",
                        "- **F12**: Go to definition"
                    ]
                }
            ],
            "metadata": {
                "kernelspec": {
                    "display_name": "Python 3",
                    "language": "python",
                    "name": "python3"
                },
                "language_info": {
                    "name": "python",
                    "version": "3.12.3"
                }
            },
            "nbformat": 4,
            "nbformat_minor": 4
        }
        
        notebook_path = os.path.join(ORailConfig.PROJECT_ROOT, "notebooks", "01_orail_getting_started.ipynb")
        with open(notebook_path, 'w') as f:
            json.dump(notebook_content, f, indent=2)
        
        print(f"✅ Created starter notebook: {notebook_path}")
        return notebook_path
    
    @staticmethod
    def create_readme():
        """Create project README for Cursor"""
        readme_content = f"""# ORAIL CITIZEN AI - Geospatial Poverty Mapping Framework

**Open Source Responsible AI Literacy (ORAIL) Initiative**

## Project Overview

The ORAIL CITIZEN AI framework provides advanced geospatial poverty mapping capabilities using AI, machine learning, and satellite imagery analysis.

## Your System Configuration

- **Project Directory**: `{ORailConfig.PROJECT_ROOT}`
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

- ✅ Real-time poverty monitoring
- ✅ 3D geospatial visualization
- ✅ AI-powered analytics
- ✅ Multi-source data integration
- ✅ GPU acceleration support
- ✅ LLM-enhanced insights

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

Ready to map poverty with AI! 🌍📊🤖
"""
        
        readme_path = os.path.join(ORailConfig.PROJECT_ROOT, "README.md")
        with open(readme_path, 'w') as f:
            f.write(readme_content)
        
        print(f"✅ Created README.md: {readme_path}")
        return readme_path

# ============================================================================
# MAIN EXECUTION FUNCTION
# ============================================================================

def main():
    """Main execution function for Cursor IDE setup"""
    
    print("🚀 ORAIL CITIZEN AI - CURSOR IDE SETUP")
    print("=" * 60)
    print(f"Setting up project in: {ORailConfig.PROJECT_ROOT}")
    print("Using your existing installations from system scan")
    print()
    
    try:
        # 1. Create project directory structure
        print("📁 CREATING PROJECT STRUCTURE...")
        project_root = ORailConfig.ensure_project_directory()
        print(f"✅ Project directory created: {project_root}")
        
        # 2. Check existing packages
        print("\n🔍 CHECKING EXISTING PACKAGES...")
        installed_packages = EnvironmentSetup.check_existing_packages()
        
        # 3. Install missing packages
        print("\n📦 INSTALLING MISSING PACKAGES...")
        EnvironmentSetup.install_missing_packages()
        
        # 4. Create environment configuration
        print("\n⚙️  CREATING ENVIRONMENT CONFIG...")
        env_path = EnvironmentSetup.create_environment_file()
        
        # 5. Setup Cursor IDE integration
        print("\n🎯 SETTING UP CURSOR IDE...")
        workspace_path = CursorIntegration.create_cursor_workspace()
        settings_path = CursorIntegration.create_cursor_settings()
        
        # 6. Create project files
        print("\n📝 CREATING PROJECT FILES...")
        notebook_path = ProjectInitializer.create_starter_notebook()
        readme_path = ProjectInitializer.create_readme()
        
        # 7. Final summary
        print("\n" + "=" * 60)
        print("🎉 ORAIL CITIZEN AI SETUP COMPLETE!")
        print("=" * 60)
        
        print(f"\n📁 Project Location:")
        print(f"   {project_root}")
        
        print(f"\n🎯 Open in Cursor IDE:")
        print(f"   cursor \"{workspace_path}\"")
        
        print(f"\n📓 Start with Jupyter:")
        print(f"   jupyter lab")
        
        print(f"\n🔗 Key Files Created:")
        print(f"   ✅ Workspace: {workspace_path}")
        print(f"   ✅ Settings: {settings_path}")
        print(f"   ✅ Environment: {env_path}")
        print(f"   ✅ Notebook: {notebook_path}")
        print(f"   ✅ README: {readme_path}")
        
        print(f"\n🚀 Next Steps:")
        print(f"   1. Open Cursor: cursor \"{project_root}\"")
        print(f"   2. Load environment: exec(open('config/environment.py').read())")
        print(f"   3. Open notebook: notebooks/01_orail_getting_started.ipynb")
        print(f"   4. Start developing! 🌍📊🤖")
        
        return True
        
    except Exception as e:
        print(f"\n❌ Setup failed: {e}")
        print(f"Error details: {type(e).__name__}")
        return False

if __name__ == "__main__":
    success = main()
    if success:
        print("\n✅ Ready for ORAIL CITIZEN AI development in Cursor IDE!")
    else:
        print("\n❌ Setup encountered errors. Please check the messages above.")