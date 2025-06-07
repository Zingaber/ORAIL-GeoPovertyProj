import os
import json
from pathlib import Path

print('ORAIL CITIZEN AI - Simple Setup')
print('=' * 40)

# Project root
project_root = os.getcwd()
print(f'Project root: {project_root}')

# Create directories
dirs = [
    'data/raw', 'data/processed', 'data/cache',
    'models/trained', 'models/configs',
    'outputs/maps', 'outputs/reports', 'outputs/visualizations',
    'scripts/python', 'scripts/r', 'scripts/sql',
    'notebooks', 'config', 'logs', '.vscode'
]

print('Creating directories...')
for d in dirs:
    os.makedirs(d, exist_ok=True)
    print(f'  Created: {d}')

# Create environment file
env_content = '''import os
import sys
import warnings
warnings.filterwarnings('ignore')

PROJECT_ROOT = os.getcwd()
print(f'ORAIL CITIZEN AI Environment Loaded')
print(f'Project root: {PROJECT_ROOT}')

try:
    import numpy as np
    import pandas as pd
    print(f'NumPy: {np.__version__}')
    print(f'Pandas: {pd.__version__}')
except ImportError as e:
    print(f'Package import error: {e}')

try:
    import torch
    if torch.cuda.is_available():
        print(f'GPU: {torch.cuda.get_device_name(0)}')
    else:
        print('Using CPU')
except ImportError:
    print('PyTorch not available')
'''

with open('config/environment.py', 'w') as f:
    f.write(env_content)
print('Created: config/environment.py')

# Create VS Code settings
vscode_settings = {
    "python.defaultInterpreterPath": "C:/Users/josze/anaconda3/User-quantuM-CDAC-CLASS/anaconda3/python.exe",
    "jupyter.jupyterServerType": "local",
    "files.watcherExclude": {
        "**/temp/**": True,
        "**/__pycache__/**": True
    }
}

with open('.vscode/settings.json', 'w') as f:
    json.dump(vscode_settings, f, indent=2)
print('Created: .vscode/settings.json')

# Create starter notebook
notebook = {
    "cells": [
        {
            "cell_type": "markdown",
            "metadata": {},
            "source": ["# ORAIL CITIZEN AI - Getting Started"]
        },
        {
            "cell_type": "code",
            "execution_count": None,
            "metadata": {},
            "source": ["exec(open('../config/environment.py').read())"]
        },
        {
            "cell_type": "code",
            "execution_count": None,
            "metadata": {},
            "source": [
                "import numpy as np\n",
                "import pandas as pd\n",
                "print('System ready for ORAIL CITIZEN AI development')"
            ]
        }
    ],
    "metadata": {
        "kernelspec": {"display_name": "Python 3", "language": "python", "name": "python3"}
    },
    "nbformat": 4,
    "nbformat_minor": 4
}

with open('notebooks/getting_started.ipynb', 'w') as f:
    json.dump(notebook, f, indent=2)
print('Created: notebooks/getting_started.ipynb')

# Create README
readme = '''# ORAIL CITIZEN AI - Geospatial Poverty Mapping

## Quick Start

1. Open Cursor: cursor .
2. Load environment: exec(open('config/environment.py').read())
3. Start Jupyter: jupyter lab
4. Open notebook: notebooks/getting_started.ipynb

## Contact
- Author: Joseph V Thomas  
- Email: citizen-ai@orail.org
- License: Creative Commons
'''

with open('README.md', 'w') as f:
    f.write(readme)
print('Created: README.md')

print('\nSetup complete!')
print('Next steps:')
print('1. cursor .')
print('2. jupyter lab')
print('3. Open notebooks/getting_started.ipynb')
