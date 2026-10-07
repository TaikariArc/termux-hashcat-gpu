#!/data/data/com.termux/files/usr/bin/bash
# clone 三个依赖 (clspv/clvk/hashcat)
set -e
H=$HOME
mkdir -p $H/deps && cd $H/deps
[ -d clspv ]   || git clone git@github.com:google/clspv.git
[ -d clvk ]    || git clone git@github.com:kpet/clvk.git
[ -d hashcat ] || git clone git@github.com:hashcat/hashcat.git
cd clspv && python3 utils/fetch_sources.py
cd ../clvk && git submodule update --init --recursive
echo "✓ 依赖拉取完成"
