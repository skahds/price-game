extern number outlineSize;
extern vec4 outlineColor;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 texColor = Texel(texture, texture_coords);
    
    // If this pixel is already opaque, just return it
    if (texColor.a > 0.5) {
        return texColor * color;
    }
    
    // Check surrounding pixels for outline
    vec2 texelSize = 1.0 / love_ScreenSize.xy;
    float maxAlpha = 0.0;
    
    // Sample in multiple directions with more samples for smoother outline
    int samples = 16; // More samples = smoother outline
    float angleStep = 6.28318 / float(samples);
    
    for (int i = 0; i < samples; i++) {
        float angle = float(i) * angleStep;
        vec2 offset = vec2(cos(angle), sin(angle)) * texelSize * outlineSize;
        vec4 sample = Texel(texture, texture_coords + offset);
        maxAlpha = max(maxAlpha, sample.a);
    }
    
    // Draw outline where we detected nearby opaque pixels
    if (maxAlpha > 0.1) {
        return outlineColor;
    }
    
    return vec4(0.0); // Fully transparent
}