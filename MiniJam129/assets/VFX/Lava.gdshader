shader_type canvas_item;
render_mode skip_vertex_transform;
uniform sampler2D NOISE_PATTERN:repeat_enable;
uniform sampler2D BUBBLE_MASK:repeat_enable,filter_linear_mipmap_anisotropic;
varying vec2 lavaUV;
varying vec2 noiseUV;
varying vec2 bubbleUV;
varying vec2 world_pos;
uniform vec3 lavaA = vec3(0,0,0);
uniform vec3 lavaB = vec3(0,0,0);
//uniform vec3 lavaA = vec3(255.0,191.0/255.0,3.0/255.0);
//uniform vec3 lavaB = vec3(232.0/255.0,91.0/255.0,4.0/255.0);
const float tile_size = 1.0 / 64.0;

vec2 get_cell_uv(vec2 uv, vec2 pixel_size) {
	vec2 ut = uv;
	ut.x = mod(1.0 - uv.x, pixel_size.x / tile_size) / pixel_size.x * tile_size;
	ut.y = mod(1.0 - uv.y, pixel_size.y / tile_size) / pixel_size.y * tile_size;
	
	return ut;
}

void fragment() {
	noiseUV = world_pos * 0.002;
	bubbleUV = world_pos * 0.005;
	
	float noise = texture(NOISE_PATTERN, TIME*0.1 + noiseUV).x;
	float bubble = texture(BUBBLE_MASK,bubbleUV + vec2(0,TIME*0.1)).x;
	
	bubble = bubble*(1.0-max(pow(1.0-UV.y*2.0,15.0),pow(UV.y*2.0,3.0)));
	bubble = bubble * pow(noise,0.5);
	
	vec2 roundedUV = round(UV*40.0)/40.0;
	lavaUV = vec2(UV.x,UV.y-noise*0.1+0.05);
	
	vec4 lavaColor = vec4(mix(lavaA,lavaB,lavaUV.y*2.0),texture(TEXTURE,lavaUV).a);
	lavaUV += vec2(0,bubble * 0.4 * noise);	
	vec4 bubbleColor = vec4(mix(lavaA,lavaB,lavaUV.y).rgb,texture(TEXTURE,lavaUV).a);
	COLOR.rgb = mix(lavaColor.rgb,bubbleColor.rgb,1.0-step(bubble,0.4));
	COLOR.a = mix(lavaColor.a,bubbleColor.a,1.0-step(bubble,0.01));
	
}
void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0, 1)).xy;	
    VERTEX = (MODEL_MATRIX * vec4(VERTEX, 0, 1)).xy;
}
