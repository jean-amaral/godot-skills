shader_type spatial;
render_mode specular_schlick_ggx;

// Terreno de dois materiais por inclinacao (plano x ingreme), com ruido
// quebrando a fronteira e variacao macro contra repeticao.
uniform sampler2D flat_albedo : source_color, repeat_enable;
uniform sampler2D steep_albedo : source_color, repeat_enable;
uniform sampler2D blend_noise : repeat_enable;
uniform float texture_scale : hint_range(0.05, 4.0) = 0.35;
uniform float macro_scale : hint_range(0.005, 0.5) = 0.03;
uniform float slope_start : hint_range(0.0, 1.0) = 0.65;
uniform float slope_end : hint_range(0.0, 1.0) = 0.85;

varying vec3 world_normal;
varying vec3 world_pos;

void vertex() {
	world_normal = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	vec2 uv = world_pos.xz * texture_scale;
	float noise = texture(blend_noise, world_pos.xz * macro_scale).r;
	float slope = 1.0 - world_normal.y;
	float blend_factor = smoothstep(slope_start, slope_end, slope + (noise - 0.5) * 0.25);
	vec3 flat_col = texture(flat_albedo, uv).rgb;
	vec3 steep_col = texture(steep_albedo, uv).rgb;
	ALBEDO = mix(flat_col, steep_col, blend_factor) * (0.85 + noise * 0.3);
	ROUGHNESS = mix(0.95, 0.85, blend_factor);
	SPECULAR = 0.35;
}
