# Termux + Adreno 660 GPU hashcat

在 Android/Termux 上用自编译的 clspv + clvk，让 hashcat 走 GPU 硬件加速。

## 现状

| 模式 | 状态 | 速度 (Adreno 660) |
|------|------|-------------------|
| -m 0  (MD5)         | 可用 | 836 MH/s (带 -O) |
| -m 100 (SHA1)       | 可用 | 数十 MH/s |
| -m 150/1450 (HMAC)  | 挂   | clspv padding struct bug |
| -m 12000 (PBKDF2)   | 挂   | 同上 |
| -m 13600 (WinZip)   | 挂   | 同上 |

## 环境
- 设备: OnePlus 9 Pro (Adreno 660, 骁龙 888)
- 系统: Android 14, Termux
- 栈: Turnip (Vulkan) + clvk + clspv + hashcat v7.1.2

## 用法

    cd ~/hashcat
    ./hashcat -a 3 -m <模式> -d 1 -w 1 -O --runtime 60 <hash> '<掩码>'
    #                                              ^ 必须 -O，速度差 50 倍

## 复现构建
见 scripts/ 目录。

## 未解 bug
见 FINDINGS.md 和 docs/known-issues.md。

## 关键文档
- FINDINGS.md - clspv padding struct bug 完整定位过程
- docs/environment.md - 环境细节
