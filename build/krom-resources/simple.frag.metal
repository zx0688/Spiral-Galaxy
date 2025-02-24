// simple_frag_main

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct simple_frag_main_uniforms
{
};
struct simple_frag_main_out
{
    float4 fragColor [[color(0)]];
};

struct simple_frag_main_in
{
    float2 vUV [[user(locn0)]];
};

fragment simple_frag_main_out simple_frag_main(simple_frag_main_in in [[stage_in]], texture2d<float> myTextureSampler [[texture(0)]], sampler myTextureSamplerSmplr [[sampler(0)]])
{
    simple_frag_main_out out = {};
    float4 color = myTextureSampler.sample(myTextureSamplerSmplr, in.vUV);
    if (color.w < 0.100000001490116119384765625)
    {
        discard_fragment();
    }
    out.fragColor = color;
    return out;
}

