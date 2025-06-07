
# PowerShell - Exhaustive System Inventory Script
$output = "system_inventory_cursor_plus.txt"
"🧠 Full System Inventory - $(Get-Date)" | Out-File $output
"=============================================" | Out-File $output -Append

function Section($title) {
    "`n### $title`n" | Out-File $output -Append
}

# 1. Basic System Info
Section "🖥️ System Information"
Get-ComputerInfo | Out-File $output -Append
Get-WmiObject Win32_OperatingSystem | Out-File $output -Append

# 2. Environment Variables
Section "📦 Environment Variables"
Get-ChildItem Env: | Out-File $output -Append

# 3. Python & Conda
Section "🐍 Python & Conda Environments"
Get-Command python, python3 -ErrorAction SilentlyContinue | Out-File $output -Append
python --version 2>> $null | Out-File $output -Append
pip list | Out-File $output -Append
conda info 2>> $null | Out-File $output -Append
conda env list | Out-File $output -Append

# 4. R Environment
Section "📊 R Language Setup"
Get-Command R -ErrorAction SilentlyContinue | Out-File $output -Append
R --version 2>> $null | Out-File $output -Append
Rscript -e ".libPaths()" | Out-File $output -Append
Rscript -e "write.csv(installed.packages()[,c('Package','Version')], 'R_packages.csv')" 2>> $null

# 5. Node.js, npm
Section "🟢 Node.js & npm"
Get-Command node, npm -ErrorAction SilentlyContinue | Out-File $output -Append
node -v | Out-File $output -Append
npm -v | Out-File $output -Append
npm list -g --depth=0 | Out-File $output -Append

# 6. Java
Section "☕ Java"
Get-Command java -ErrorAction SilentlyContinue | Out-File $output -Append
java -version 2>> $null | Out-File $output -Append

# 7. VS Code Extensions
Section "🧩 VS Code Extensions"
code --list-extensions | Out-File $output -Append

# 8. Jupyter Kernels
Section "📚 Jupyter Kernels"
jupyter kernelspec list | Out-File $output -Append

# 9. AI/ML Libraries
Section "🧠 AI/ML Python Packages"
pip show torch tensorflow scikit-learn transformers xgboost lightgbm langchain | Out-File $output -Append

# 10. Docker & Containers
Section "🐳 Docker & Containers"
Get-Command docker -ErrorAction SilentlyContinue | Out-File $output -Append
docker info | Out-File $output -Append
docker ps -a | Out-File $output -Append
docker images | Out-File $output -Append

# 11. WSL and Linux
Section "🐧 WSL Distros"
wsl --list --verbose | Out-File $output -Append

# 12. Databases
Section "🗄️ Database Installations"
Get-Command psql, mysql, mongod, sqlite3 -ErrorAction SilentlyContinue | Out-File $output -Append
psql --version 2>> $null | Out-File $output -Append
mysql --version 2>> $null | Out-File $output -Append
mongod --version 2>> $null | Out-File $output -Append
sqlite3 --version 2>> $null | Out-File $output -Append

# 13. CUDA and GPU
Section "🎮 CUDA & GPU Info"
Get-Command nvidia-smi -ErrorAction SilentlyContinue | Out-File $output -Append
nvidia-smi | Out-File $output -Append

# 14. Git
Section "🔄 Git"
Get-Command git -ErrorAction SilentlyContinue | Out-File $output -Append
git --version | Out-File $output -Append

# 15. PATH & Directory Structure
Section "📂 PATH & System Directories"
$env:PATH -split ';' | Out-File $output -Append

# 16. Directory Tree Overview
Section "🗂️ User Workspace Directory Mapping"
Get-ChildItem -Path "$HOME" -Recurse -Directory -Depth 2 -ErrorAction SilentlyContinue | Out-File $output -Append

"`n✅ Full Inventory completed. Output saved to $output" | Out-File $output -Append
