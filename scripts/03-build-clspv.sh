#!/data/data/com.termux/files/usr/bin/bash
set -e
H=$HOME
P=$PREFIX
cd $H/deps/clspv
mkdir -p build && cd build
cmake .. \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$P
ninja -j2
ninja install
echo "✓ clspv built"
