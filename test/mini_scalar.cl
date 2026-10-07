typedef struct {
    uint h[5];
    uint w0[4];
    uint w1[4];
    uint w2[4];
    uint w3[4];
    int  len;
} sha1_ctx_t;

typedef struct {
    sha1_ctx_t ipad;
    sha1_ctx_t opad;
} sha1_hmac_ctx_t;

__kernel void test(__global uint *in, __global uint *out) {
    sha1_hmac_ctx_t ctx = { 0 };

    // 从运行时输入读,阻止常量折叠
    ctx.ipad.h[0] = in[0];
    ctx.ipad.h[1] = in[1];
    ctx.ipad.h[2] = in[2];
    ctx.ipad.h[3] = in[3];
    ctx.ipad.h[4] = in[4];

    ctx.opad.h[0] = in[5];
    ctx.opad.h[1] = in[6];
    ctx.opad.h[2] = in[7];
    ctx.opad.h[3] = in[8];
    ctx.opad.h[4] = in[9];

    // 跨字段复制(模拟 sha1_hmac_final)
    ctx.opad.w0[0] = ctx.ipad.h[0];
    ctx.opad.w0[1] = ctx.ipad.h[1];

    // 输出全部
    out[0] = ctx.ipad.h[0];   // 期望 in[0]
    out[1] = ctx.ipad.h[1];   // 期望 in[1]
    out[2] = ctx.ipad.h[4];   // 期望 in[4]
    out[3] = ctx.opad.h[0];   // 期望 in[5]
    out[4] = ctx.opad.h[4];   // 期望 in[9]
    out[5] = ctx.opad.w0[0];  // 期望 in[0] (从 ipad 复制过来)
    out[6] = ctx.opad.w0[1];  // 期望 in[1]
}
