# ORAIL CITIZEN AI - Environment Configuration
# Generated for Cursor IDE

import os
import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import warnings
warnings.filterwarnings('ignore')

# Project configuration
PROJECT_ROOT = 'C:/Users/josze/MYRworkspace-CitizenAI-poverty-mapping'
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
        print(f'GPU: {torch.cuda.get_device_name(0)}')
        print(f'CUDA version: {torch.version.cuda}')
    else:
        device = torch.device('cpu')
        print('Using CPU for PyTorch')
    
    # TensorFlow GPU setup
    gpus = tf.config.experimental.list_physical_devices('GPU')
    if gpus:
        try:
            for gpu in gpus:
                tf.config.experimental.set_memory_growth(gpu, True)
            print(f'TensorFlow GPU: {len(gpus)} device(s) available')
        except RuntimeError as e:
            print(f'GPU config error: {e}')
    
except ImportError as e:
    print(f'GPU libraries not available: {e}')
    device = 'cpu'

# Configure matplotlib for better plots
plt.style.use('default')
plt.rcParams['figure.figsize'] = (12, 8)
plt.rcParams['font.size'] = 10

print('ORAIL CITIZEN AI Environment Loaded')
print(f'Project root: {PROJECT_ROOT}')
print(f'Python: {sys.version.split()[0]}')
print(f'NumPy: {np.__version__}')
print(f'Pandas: {pd.__version__}')
