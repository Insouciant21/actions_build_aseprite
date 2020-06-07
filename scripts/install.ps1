# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# Install dependencies
choco install cmake visualstudio2019community ninja windows-sdk-10.1 git jq grep curl wget 7zip -y
# Get source code
mkdir Windows
cd Windows
$source=$(curl -sL https://api.github.com/repos/aseprite/aseprite/releases/latest | jq -r '.assets[].browser_download_url')
$skia=$(curl -sL https://api.github.com/repos/aseprite/skia/releases/latest | jq -r '.assets[].browser_download_url' | grep Windows | grep 64)
wget -nv -O source.zip $source
wget -nv -O skia.zip $skia
7z x source.zip -oaseprite | grep ing 
7z x skia.zip -oskia | grep ing 
cd aseprite
mkdir build