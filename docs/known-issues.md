# 未解 bug

## clspv padding struct 处理错误
详见 ../FINDINGS.md 第 4 层。

影响范围: 所有含嵌套 struct + padding 的 OpenCL 内核。
具体到 hashcat:
- -m 150 HMAC-SHA1
- -m 1450 HMAC-SHA256
- -m 2500 WPA-PBKDF2-PMKID+EAPOL
- -m 12000 PBKDF2-HMAC-SHA1
- -m 13600 WinZip AES
- 其他用 sha1_hmac_ctx_t / sha256_hmac_ctx_t 的

## 性能回退
MD5 从历史峰值 144 MH/s 降到 836 MH/s 是好的方向（带 -O），
但跟 PC 上 RTX 3060 (~50 GH/s) 差距 60 倍。

## 已知 workaround（牺牲功能换稳定）
- 禁用 SROA: 修 offset 88->96 bug，但 MD5 慢 10 倍
- 注释 SGEP/DGEP: 修 GEP 丢索引，但可能影响其他场景
- 均不推荐长期使用
