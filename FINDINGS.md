# clspv bug 定位完整记录

## 症状
hashcat 的 HMAC/PBKDF2 类内核（含嵌套 struct 如 sha1_hmac_ctx_t）编译出的 SPIR-V 语义错误：
- ctx.opad.h[0]（offset 88/352）被读成 ctx.opad.h[2]（offset 96/384）
- IR 层 getelementptr 是正确的（i32 0, i32 1, i32 0, i32 0）
- 但 clspv 生成的 OpAccessChain 把 i32 2 静默改成了 i32 0

## 触发条件
1. struct 尾部是裸标量字段（如 int len），而非数组
2. struct 有 padding：warning: padding size of 'sha1_ctx_vector_t' with 12 bytes to alignment boundary
3. 嵌套 struct（sha1_hmac_ctx_t = { sha1_ctx_t ipad; sha1_ctx_t opad; }）
4. O0/O1/O2 都复现，与 LLVM 优化级别无关

## 已知 bug 层（4 层）

### 1. memmove 展开崩溃
- 文件: clspv/lib/ReplaceLLVMIntrinsicsPass.cpp
- 问题: expandMemMoveAsLoop 跨地址空间失败
- 修复: fallback 到 createMemCpyLoopKnownSize/UnknownSize

### 2. SROA 折叠错误
- 影响: struct offset 88 被算成 96
- 临时方案: 在 Compiler.cpp 注释掉 SROAPass
- 代价: MD5 从 836 MH/s 掉到 14.8 MH/s（已恢复 SROA）

### 3. StructurizeGEP/DestructurizeGEP round-trip 丢索引
- 影响: i32 2 变 i32 0
- 证据: 注释掉两个 pass 后 mini 标量用例正确
- 但 hashcat 向量版仍错

### 4. 未解: padding struct 处理（关键）
- 证据: warning: padding size of 'sha1_ctx_vector_t' with 12 bytes to alignment boundary
- 症状: opad 应从 offset 352 开始，clspv 算成 340 或更小
- 嫌疑:
  - clspv/lib/BitcastUtils.cpp - SizeInBits / GetIdxsForTyFromOffset / GoThroughTypeAtOffset
  - 对含 padding 的 struct，DL.getTypeAllocSizeInBits 返回错误值
- 复现: 大型 hashcat 内核（小用例无法复现，被常量折叠）

## 调试方法
1. --show-producer-ir 打印 SPIRVProducerPass 入口 IR
2. --print-pipeline-passes=text 打印 pass 序列
3. 单 pass 禁用二分（注释 pm.addPass(...) + ninja 增量 35s）
4. clspv-opt 手动跑 pass 序列

## 上游可能感兴趣的 issue
- clspv 处理 struct padding 的 offset 计算
- SROA 与 clspv 自定义 pass 的交互
- 嵌套 struct 的 GEP 索引保留
