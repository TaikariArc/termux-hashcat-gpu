#!/data/data/com.termux/files/usr/bin/bash
# 关键: clvk install 后必须覆盖 ICD 目标位置
set -e
H=$HOME
P=$PREFIX
NEWLIB=$(find $H/deps/clvk/build -name "libOpenCL.so.0.1" | head -1)
[ -n "$NEWLIB" ] || { echo "找不到 libOpenCL.so.0.1"; exit 1; }
mkdir -p $P/lib/clvk
cp -Lf "$NEWLIB" $P/lib/clvk/libOpenCL.so
echo "✓ $NEWLIB -> $P/lib/clvk/libOpenCL.so"
