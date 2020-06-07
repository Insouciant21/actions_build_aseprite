powershell.exe ./install.ps1
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\Common7\Tools\VsDevCmd.bat" -arch=x64
cd Windows
set workdir=chdir
cd aseprite
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DLAF_BACKEND=skia -DSKIA_DIR=%workdir%\skia -DSKIA_LIBRARY_DIR=%workdir%\skia\out\Release-x64 -G Ninja ..
ninja aseprite
