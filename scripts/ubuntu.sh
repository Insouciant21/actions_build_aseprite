rm -rf aseprite/ skia/ skia.zip source.zip action/
sudo apt-get install -y g++ cmake ninja-build libx11-dev libxcursor-dev libxi-dev libgl1-mesa-dev libfontconfig1-dev jq
git clone https://github.com/Insouciant21/action_aseprite.git action/
ase=$(curl -sL https://api.github.com/repos/aseprite/aseprite/releases/latest | jq -r '.assets[].browser_download_url')
skia=$(curl -sL https://api.github.com/repos/aseprite/skia/releases/latest | jq -r '.assets[].browser_download_url' | grep Linux | grep 64)
wget -q -O source.zip $ase
wget -q -O skia.zip $skia
7z x source.zip -oaseprite
7z x skia.zip -oskia
workdir=$(pwd)
cd aseprite
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLAF_BACKEND=skia -DSKIA_DIR=$workdir/skia -DSKIA_LIBRARY_DIR=$workdir/skia/out/Release-x64 -G Ninja ..
ninja aseprite
cd $workdir/action
mkdir deb-frame/usr/share/aseprite
rm -rf $workdir/aseprite/build/bin/modp_b64_gen
rm -rf $workdir/aseprite/build/bin/gen
cp -r $workdir/aseprite/build/bin/* deb-frame/usr/share/aseprite/
dpkg -b deb-frame aseprite-linux64.deb
cd ..
mv action/aseprite-linux64.deb .
