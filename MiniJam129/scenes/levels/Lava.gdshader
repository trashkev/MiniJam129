shader_type canvas_item;
render_mode skip_vertex_transform;
uniform sampler2D NOISE_PATTERN:repeat_enable,filter_linear_mipmap_anisotropic;
uniform sampler2D BUBBLE_MASK:repeat_enable,filter_linear_mipmap_anisotropic;
varying vec2 lavaUV;
varying vec2 noiseUV;
varying vec2 bubbleUV;
varying vec2 world_pos;
uniform vec2 camera_matrix;

const float tile_size = 1.0 / 64.0;

vec2 get_cell_uv(vec2 uv, vec2 pixel_size) {
	vec2 ut = uv;
	ut.x = mod(1.0 - uv.x, pixel_size.x / tile_size) / pixel_size.x * tile_size;
	ut.y = mod(1.0 - uv.y, pixel_size.y / tile_size) / pixel_size.y * tile_size;
	
	return ut;
}

void fragment() {
	noiseUV = world_pos*0.002;
	bubbleUV = world_pos * 0.005;
	//COLOR.r = lavaUV.x;
	//COLOR.g = lavaUV.y;
	float noise = texture(NOISE_PATTERN, TIME*0.1 + noiseUV).x;
	float bubble = texture(BUBBLE_MASK,bubbleUV + vec2(0,TIME*0.1)).x;
	lavaUV = vec2(UV.x,UV.y-noise*0.1+0.05);
	//lavaUV += vec2(0,UV.y *0.01+ bubble*noise*UV.y);
	COLOR = texture(TEXTURE,lavaUV);
	//COLOR.r = get_cell_uv(UV,TEXTURE_PIXEL_SIZE).x;
	//COLOR.g = get_cell_uv(UV,TEXTURE_PIXEL_SIZE).y;
	//COLOR.r = world_pos.x*0.001;
	//COLOR.g = world_pos.y*0.001;
	
	//COLOR.r = 1.0-step(bubble*0.5*noise*clamp(0.5+UV.y*1.0,0.0,1.0),0.1);
	//COLOR.g = 1.0-step(bubble*0.5*noise*clamp(0.5+UV.y*1.0,0.0,1.0),0.1);
	//COLOR.b = 1.0-step(bubble*0.5*noise*clamp(0.5+UV.y*1.0,0.0,1.0),0.1);
	
	
}
void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0, 1)).xy;	
    VERTEX = (MODEL_MATRIX * vec4(VERTEX, 0, 1)).xy;
}
