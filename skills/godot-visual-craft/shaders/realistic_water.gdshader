shader_type spatial;
render_mode blend_mix, depth_draw_opaque, specular_schlick_ggx;

// Agua realista-base: fluxo por dois scrolls de normal, fresnel raso/profundo
// e espuma de margem por profundidade. Ajuste contra a sua referencia.
uniform sampler2D normal_map : hint_normal, repeat_enable;
uniform vec4 shallow_color : source_color = vec4(0.25, 0.55, 0.60, 0.55);
uniform vec4 deep_color : source_color = vec4(0.02, 0.16, 0.25, 0.92);
uniform float flow_speed : hint_range(0.0, 2.0) = 0.35;
uniform float normal_scale : hint_range(0.5, 40.0) = 8.0;
uniform float foam_distance : hint_range(0.05, 3.0) = 0.6;
uniform sampler2D depth_texture : hint_depth_texture, repeat_disable;

void fragment() {
	vec2 uv_a = UV * normal_scale + vec2(TIME * flow_speed, TIME * flow_speed * 0.6);
	vec2 uv_b = UV * normal_scale * 1.7 - vec2(TIME * flow_speed * 0.8, TIME * flow_speed);
	vec3 n = texture(normal_map, uv_a).rgb * texture(normal_map, uv_b).rgb;
	NORMAL_MAP = normalize(vec3(n.rg * 2.0 - 1.0, 1.0));
	float fresnel = pow(1.0 - dot(NORMAL, VIEW), 3.0);
	float scene_depth_raw = texture(depth_texture, SCREEN_UV).r;
	float scene_depth = PROJECTION_MATRIX[3][2] / (scene_depth_raw * PROJECTION_MATRIX[2][2] + PROJECTION_MATRIX[2][3]);
	float shore = clamp(1.0 - (scene_depth - (-VERTEX.z)) / foam_distance, 0.0, 1.0);
	vec4 col = mix(shallow_color, deep_color, fresnel);
	col.rgb = mix(col.rgb, vec3(1.0), smoothstep(0.65, 0.95, shore));
	ALBEDO = col.rgb;
	ALPHA = mix(col.a, 1.0, shore * 0.6);
	ROUGHNESS = 0.08;
	SPECULAR = 0.65;
}
