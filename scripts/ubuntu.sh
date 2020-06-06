#!/bin/bash
# Clean environment
clear
echo -e "\033[31mClean environment\033[0m"
rm -rf ubuntu/
mkdir ubuntu
cd ubuntu
# Install dependencies
clear
echo -e "\033[31mInstall dependencies\033[0m"
sudo apt-get install -y g++ cmake ninja-build libx11-dev libxcursor-dev libxi-dev libgl1-mesa-dev libfontconfig1-dev jq
# Get source
clear
echo -e "\033[31mGet Source\033[0m"
source=$(curl -sL https://api.github.com/repos/aseprite/aseprite/releases/latest | jq -r '.assets[].browser_download_url')
skia=$(curl -sL https://api.github.com/repos/aseprite/skia/releases/latest | jq -r '.assets[].browser_download_url' | grep Linux | grep 64)
wget -q -O source.zip $source
wget -q -O skia.zip $skia
7z x source.zip -oaseprite
7z x skia.zip -oskia
# Start Building
clear
echo -e "\033[31mStart Building\033[0m"
workdir=$(pwd)
cd aseprite
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DLAF_BACKEND=skia -DSKIA_DIR=$workdir/skia -DSKIA_LIBRARY_DIR=$workdir/skia/out/Release-x64 -G Ninja ..
ninja aseprite
# Package
clear
echo -e "\033[31mPackage\033[0m"
cd $workdir
mkdir ../../deb-frame/usr/share/aseprite
#rm -rf $workdir/aseprite/build/bin/modp_b64_gen
#rm -rf $workdir/aseprite/build/bin/gen
cp -r $workdir/aseprite/build/bin/* ../../deb-frame/usr/share/aseprite/
dpkg -b ../../deb-frame aseprite-linux64.deb
where=$(readlink -f $workdir/aseprite-linux64.deb)
if [ -e $workdir/aseprite-linux64.deb ]
then
 echo -e "\033[32mSuccessful\033[0m"
 echo "Install by using" 
 echo "sudo dpkg install" $where
else
 echo -e "\033[31mFailed\033[0m"
fi
