shader_type canvas_item;
render_mode skip_vertex_transform;
uniform sampler2D NOISE_PATTERN:repeat_enable,filter_linear;
uniform sampler2D BUBBLE_MASK:repeat_enable,filter_nearest;
varying vec2 lavaUV;
varying vec2 noiseUV;
varying vec2 bubbleUV;
varying vec2 world_pos;
uniform vec3 lavaA = vec3(0,0,0);
uniform vec3 lavaB = vec3(0,0,0);
const float tile_size = 1.0 / 64.0;

vec2 get_cell_uv(vec2 uv, vec2 pixel_size) {
	vec2 ut = uv;
	ut.x = mod(1.0 - uv.x, pixel_size.x / tile_size) / pixel_size.x * tile_size;
	ut.y = mod(1.0 - uv.y, pixel_size.y / tile_size) / pixel_size.y * tile_size;
	
	return ut;
}

void fragment() {
	vec2 bubblePixelFactor = vec2(32.0/64.0,32.0/64.0);
	vec2 noisePixelFactor = vec2(16.0/64.0,50.0/64.0);
	vec2 lavaPixelFactor = vec2(18.0/64.0,1500.0/64.0);
	//noiseUV	 = vec2(world_pos * 0.002);
	noiseUV = vec2(round(world_pos.x * noisePixelFactor.x)/noisePixelFactor.x,round(world_pos.y * noisePixelFactor.y)/noisePixelFactor.y) * 0.002;
	bubbleUV = vec2(world_pos*0.005);
	//bubbleUV = vec2(round(world_pos.x * bubblePixelFactor.x)/bubblePixelFactor.x,round(world_pos.y * bubblePixelFactor.y)/bubblePixelFactor.y) * 0.005;
	
	float noise = texture(NOISE_PATTERN, TIME*0.08 + noiseUV).x;
	float bubble = texture(BUBBLE_MASK,bubbleUV + vec2(0,TIME*0.1)).x;
	
	bubble = bubble*(1.0-max(pow(1.0-UV.y*2.0,15.0),pow(UV.y*2.0,3.0)));
	//bubble = bubble * pow(noise,0.5);
	
	lavaUV = vec2(UV.x,UV.y-noise*0.1+0.05);	
	//lavaUV = vec2(round(lavaUV.x * lavaPixelFactor.x)/lavaPixelFactor.x,round(lavaUV.y * lavaPixelFactor.y)/lavaPixelFactor.y); 	
	vec4 lavaColor = vec4(mix(lavaA,lavaB,lavaUV.y*2.0),texture(TEXTURE,lavaUV).a);
	lavaUV += vec2(0,bubble * 0.4 * noise);	
	
	vec4 bubbleColor = vec4(mix(lavaA,lavaB,lavaUV.y).rgb,texture(TEXTURE,lavaUV).a);
	
	COLOR.rgb = mix(lavaColor.rgb,bubbleColor.rgb,1.0-step(bubble,0.4));
	//COLOR.rg = lavaUV.xy;
	//COLOR.rgb = lavaColor.rgb;
	//COLOR.a = lavaColor.a;
	COLOR.a = (pow(UV.y,0.03)) * 0.95 * mix(lavaColor.a,bubbleColor.a,step(bubble,0.01));
}
void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0, 1)).xy;	
    VERTEX = (MODEL_MATRIX * vec4(VERTEX, 0, 1)).xy;
}
