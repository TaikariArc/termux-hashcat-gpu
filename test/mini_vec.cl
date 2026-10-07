typedef unsigned int uint4 __attribute__((ext_vector_type(4)));
typedef struct {
    uint4 h[5]; uint4 w0[4]; uint4 w1[4]; uint4 w2[4]; uint4 w3[4]; int len;
} sha1_ctx_vector_t;
typedef struct { sha1_ctx_vector_t ipad; sha1_ctx_vector_t opad; } sha1_hmac_ctx_vector_t;

__kernel void test(__global uint4 *in, __global uint4 *out, __global int *idx) {
    int n = idx[0];                                    // 运行时值
    sha1_hmac_ctx_vector_t ctx;
    // 用运行时循环填，防止折叠
    for (int k = 0; k < 5; k++) ctx.ipad.h[k] = in[k];
    for (int k = 0; k < 5; k++) ctx.opad.h[k] = in[k + 5];
    ctx.ipad.len = n;
    out[0] = ctx.ipad.h[0];
    out[1] = ctx.opad.h[0];                            // ★ 关键：应该是 in[5]
    out[2] = ctx.opad.h[2];                            // ★ 应该是 in[7]
    out[3] = ctx.opad.h[4];                            // ★ 应该是 in[9]
}
