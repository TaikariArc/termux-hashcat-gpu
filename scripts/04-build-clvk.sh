#!/data/data/com.termux/files/usr/bin/bash
set -e
H=$HOME
P=$PREFIX
cd $H/deps/clvk
mkdir -p build && cd build
cmake .. \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCLSPV_SOURCE_DIR=$H/deps/clspv \
  -DCLVK_CLSPV_ONLINE_COMPILER=ON \
  -DLLVM_DIR=$H/deps/clspv/build/third_party/llvm/lib/cmake/llvm \
  -DVulkan_INCLUDE_DIR=$P/include \
  -DCMAKE_INSTALL_PREFIX=$P
ninja -j2
echo "✓ clvk built (需要手动 deploy)"
