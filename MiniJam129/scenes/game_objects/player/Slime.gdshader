shader_type canvas_item;
uniform sampler2D NOISE_PATTERN:repeat_enable;
varying float waveX;
varying float waveY;
varying vec2 uv;
void fragment() {
	uv = UV;
	float noise = texture(NOISE_PATTERN, TIME*0.05 + 0.8*vec2(UV.x,UV.y)).x;
	
	waveX = (sin(TIME * 10.0+ UV.y * 200.0)) * 0.2;
	waveY = (sin(TIME * 14.0+ UV.x * 200.0)) * 0.2;
	uv.x += waveX * 10.0 * (sin(TIME*6.0)) * (45.0 * pow(1.0-UV.x,7.0));
	uv.y += waveY * 55.0 * pow(1.0-UV.x,7.0);
	COLOR = texture(TEXTURE,UV);
	//COLOR.r = noise;
	//COLOR.b = noise;
	//COLOR.g = noise;
}
void vertex(){
}
