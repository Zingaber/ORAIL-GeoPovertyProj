@echo off
echo ORAIL CITIZEN AI - Environment Activation
echo ========================================
echo Activating conda environment and setting up project...

cd /d "C:/Users/josze/MYRworkspace-CitizenAI-poverty-mapping"
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
