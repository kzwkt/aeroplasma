#coo
pacman -Syu
pacman -Sy --noconfirm  cmake extra-cmake-modules ninja qt6-virtualkeyboard qt6-multimedia qt6-5compat plasma-wayland-protocols plasma5support kvantum base-devel
CUR_DIR=$(pwd)
USE_SCRIPT="install_ninja.sh"
A_DIR=$CUR_DIR/aerothemeplasma
git clone --depth=1 https://gitgud.io/wackyideas/aerothemeplasma
mkdir $CUR_DIR/pkg
cd "$A_DIR/misc/defaulttooltip"
sh $USE_SCRIPT
cp /usr/lib64/qt6/qml/org/kde/plasma/core/libcorebindingsplugin.so  $CUR_DIR/pkg

echo "Compiling SMOD decorations..."
cd "$A_DIR/kwin/decoration"
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$CUR_DIR/pkg ..
make
make install

echo "Compiling KWin effects..."
for filename in "$A_DIR/kwin/effects_cpp/"*; do
cd "$filename"
echo "Compiling $(pwd)"
rm -rf build-kf6
cmake -B build-kf6 -DCMAKE_INSTALL_PREFIX=$CUR_DIR/pkg -DCMAKE_BUILD_TYPE=Release -G Ninja -DBUILD_KF6=ON .
ninja -C build-kf6
sudo ninja -C build-kf6 install
echo "Done."
done

for filename in "$A_DIR/plasma/plasmoids/src/"*; do
cd "$filename"
echo "Compiling $(pwd)"
rm -rf build
mkdir build
cd build
cmake ../ -DCMAKE_INSTALL_PREFIX=$CUR_DIR/pkg -G Ninja
ninja
ninja install
echo "Done."
done

tar -czvf  aeroplasma.tar.gz $CUR_DIR/pkg

