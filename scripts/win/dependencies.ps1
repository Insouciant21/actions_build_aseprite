# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# Install dependencies
choco install cmake visualstudio2019community ninja windows-sdk-10.1 git jq grep curl wget 7zip -y
# Environment
mkdir tmp
cd tmp
# Get source code
$source=$(curl https://api.github.com/repos/aseprite/aseprite/releases/latest | Select -ExpandProperty Content | jq -r '.assets[].browser_download_url')
$skia=$(curl https://api.github.com/repos/aseprite/skia/releases/latest | Select -ExpandProperty Content| jq -r '.assets[].browser_download_url' | findstr Windows | findstr 64)
iwr -outf source.zip $source
iwr -outf skia.zip $skia
# Unzip the source code
7z x source.zip -oaseprite | findstr ing 
7z x skia.zip -oskia | findstr ing 
# Directory for build
cd aseprite
mkdir build
