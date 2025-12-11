local shaderCode = [[
    uniform float strength = 0.5;
    uniform vec2 resolution;
    
    // Scanline effect
    float scanline(vec2 uv) {
        return sin(uv.y * resolution.y * 2.0) * 0.04;
    }
    
    // Vignette effect
    float vignette(vec2 uv) {
        uv = (uv - 0.5) * 2.0;
        return 1.0 - dot(uv, uv) * 0.3;
    }
    
    // Screen curvature - scales inward to prevent edge cutoff
    vec2 curve(vec2 uv) {
        uv = uv * 2.0 - 1.0;
        vec2 offset = abs(uv.yx) / vec2(6.0, 4.0);
        uv = uv + uv * offset * offset;
        uv = uv * 0.5 + 0.5;
        
        // Scale to compensate for curvature expansion
        vec2 center = vec2(0.5, 0.5);
        float scale = 0.9; // Adjust this to control how much to scale inward
        uv = (uv - center) * scale + center;
        
        return uv;
    }
    
    vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_coords) {
        vec2 resolution = love_ScreenSize.xy;
        
        // Apply curvature
        vec2 curved_uv = mix(uv, curve(uv), strength/3);
        
        // Return black if outside bounds after curvature
        if (curved_uv.x < 0.0 || curved_uv.x > 1.0 || 
            curved_uv.y < 0.0 || curved_uv.y > 1.0) {
            return vec4(0.0, 0.0, 0.0, 1.0);
        }
        
        // Sample texture
        vec4 texColor = Texel(tex, curved_uv);
        
        // Apply scanlines
        float scan = 1.0 - scanline(curved_uv) * strength;
        texColor.rgb *= scan;
        
        // Apply vignette
        float vig = mix(1.0, vignette(curved_uv), strength * 0.5);
        texColor.rgb *= vig;
        
        // RGB shift for chromatic aberration
        float aberration = 0.002 * strength;
        float r = Texel(tex, curved_uv + vec2(aberration, 0.0)).r;
        float b = Texel(tex, curved_uv - vec2(aberration, 0.0)).b;
        texColor.r = mix(texColor.r, r, strength);
        texColor.b = mix(texColor.b, b, strength);
        
        // Slight brightness boost and contrast
        texColor.rgb = mix(texColor.rgb, pow(texColor.rgb, vec3(0.9)), strength * 0.3);
        
        return texColor * color;
    }
]]

-- Create and return the shader
local shader = love.graphics.newShader(shaderCode)

-- Initialize with default strength
shader:send("strength", 0.2)

system.updateStorage("system:shader", shader)