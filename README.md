# ORAIL CITIZEN AI - Geospatial Poverty Mapping Framework

**Open Source Responsible AI Literacy (ORAIL) Initiative**

## Project Overview

The ORAIL CITIZEN AI framework provides advanced geospatial poverty mapping capabilities using AI, machine learning, and satellite imagery analysis.

## System Configuration

- **Project Directory**: C:/Users/josze/MYRworkspace-CitizenAI-poverty-mapping
- **Python**: 3.12.3 (Anaconda)
- **GPU**: NVIDIA GeForce RTX 4070 Laptop GPU
- **TensorFlow**: 2.19.0
- **PyTorch**: 2.5.1
- **IDE**: Cursor IDE

## Quick Start with Cursor IDE

### 1. Open Project in Cursor
```bash
cd "C:/Users/josze/MYRworkspace-CitizenAI-poverty-mapping"
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
C:/Users/josze/MYRworkspace-CitizenAI-poverty-mapping/
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
