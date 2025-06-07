

# system_inventory_clean.ps1
# Fully Cleaned and Compatible PowerShell Script for System Inventory
# Outputs to system_inventory_output.txt

$output = "system_inventory_output.txt"
"===== SYSTEM INVENTORY REPORT =====" | Out-File $output -Encoding utf8

function Write-Section($title) {
    "`n==== $title ====" | Out-File $output -Append
}

Write-Section "System Info"
systeminfo | Out-File $output -Append

Write-Section "Installed R Version and Packages"
Get-Command Rscript -ErrorAction SilentlyContinue | Out-File $output -Append
if (Get-Command Rscript -ErrorAction SilentlyContinue) {
    Rscript -e ".libPaths()" | Out-File $output -Append
    Rscript -e "write.csv(installed.packages()[,c('Package','Version')], file='R_installed_packages.csv', row.names=FALSE)"
    "Saved R packages to R_installed_packages.csv" | Out-File $output -Append
} else {
    "Rscript not found." | Out-File $output -Append
}

Write-Section "Python Version and Conda Environments"
python --version 2>&1 | Out-File $output -Append
conda info --envs 2>&1 | Out-File $output -Append
conda list 2>&1 | Out-File $output -Append

Write-Section "Java Version"
java -version 2>&1 | Out-File $output -Append

Write-Section "Node.js and NPM"
node -v 2>&1 | Out-File $output -Append
npm -v 2>&1 | Out-File $output -Append

Write-Section "Git Version"
git --version 2>&1 | Out-File $output -Append

Write-Section "Docker (if available)"
docker info 2>&1 | Out-File $output -Append

Write-Section "CUDA & GPU Info (if any)"
Get-WmiObject Win32_VideoController | Select-Object Name, DriverVersion | Out-File $output -Append

Write-Section "User Python Packages (top)"
pip list | Sort-Object -Property Name | Out-File $output -Append

Write-Section "Conda Path Info"
conda info --json | Out-File $output -Append

Write-Section "Workspace Directory"
Get-ChildItem -Path . -Recurse -ErrorAction SilentlyContinue | Select-Object FullName | Out-File $output -Append

"`nInventory completed. Output saved to $output" | Out-File $output -Append
