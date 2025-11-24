	extern vec2 pixelSize;
	extern float size = 1;
	extern float smoothness = 1;

	vec4 effect(vec4 color, Image texture, vec2 uv, vec2 fc) {
		float a = 0;
		for(float y = -size; y <= size; ++y) {
			for(float x = -size; x <= size; ++x) {
				a += Texel(texture, uv + vec2(x * pixelSize.x, y * pixelSize.y)).a;
			}
		}
		a = color.a * min(1, a / (2 * size * smoothness + 1));

		return vec4(color.rgb, a);
	}