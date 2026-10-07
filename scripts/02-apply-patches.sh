#!/data/data/com.termux/files/usr/bin/bash
# 应用本项目的所有 patch
set -e
H=$HOME
PATCHROOT=$H/termux-hashcat-gpu/patches
cd $H/deps/clspv && git apply $PATCHROOT/clspv/all.patch
cd $H/deps/clvk  && git apply $PATCHROOT/clvk/all.patch
echo "✓ patch 应用完成"
