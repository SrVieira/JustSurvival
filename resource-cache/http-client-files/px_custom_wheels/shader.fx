float Brightness = 1;
float4 color = float4(1,1,1,1);

texture sTex0           < string textureState="0,Texture"; >;

sampler Sampler0 = sampler_state
{
    Texture = (sTex0);
};

float4 PixelShaderPS(float4 TexCoord : TEXCOORD0, float4 Position : POSITION, float4 Diffuse : COLOR0) : COLOR0
{
    float4 tex = tex2D(Sampler0, TexCoord);
    float4 output = saturate(tex * color);
    output.r *= 0.45 * Brightness;
    output.g *= 0.45 * Brightness;
    output.b *= 0.45 * Brightness;
    return output;
}

technique shader_tex_replace
{
    pass P0
    {
        PixelShader = compile ps_2_0 PixelShaderPS();
        LightEnable[1] = true;
        LightEnable[2] = true;
        LightEnable[3] = true;
        LightEnable[4] = true;
    }
}

technique fallback
{
    pass P0
    {
    }
}