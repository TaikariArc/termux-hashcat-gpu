# 环境

## 硬件
- OnePlus 9 Pro (LE2120)
- 骁龙 888 (SM8350)
- Adreno 660 GPU

## 软件
- Android 14 / ColorOS 14
- Termux

## 工具链
- clang: 24.0.0git (in-tree, clspv 自带)
- Python: 3.14
- CMake: 4.4
- Ninja: 1.13.2

## OpenCL 栈
- Vulkan: Turnip
- OpenCL->Vulkan: clvk (kpet/clvk)
- OpenCL->SPIR-V: clspv (google/clspv)
- hashcat: v7.1.2-859-g7096497cc

## 部署路径
- ICD 文件: $PREFIX/etc/OpenCL/vendors/clvk.icd
- ICD 指向: $PREFIX/lib/clvk/libOpenCL.so
  （注意不是 $PREFIX/lib/libOpenCL.so！）

## 关键补丁
见 patches/ 目录
