shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, specular_schlick_ggx;

// Vidro barato e crivel: borda opaca por fresnel, centro quase transparente.
// Sem refracao por padrao (custo); sujeira entra por roughness_mask.
uniform vec4 tint : source_color = vec4(0.75, 0.88, 0.92, 1.0);
uniform float edge_opacity : hint_range(0.0, 1.0) = 0.85;
uniform float center_opacity : hint_range(0.0, 1.0) = 0.08;
uniform sampler2D roughness_mask : hint_default_white, repeat_enable;
uniform float roughness_base : hint_range(0.0, 1.0) = 0.06;

void fragment() {
	float fresnel = pow(1.0 - abs(dot(normalize(NORMAL), normalize(VIEW))), 3.0);
	ALBEDO = tint.rgb;
	ALPHA = mix(center_opacity, edge_opacity, fresnel);
	ROUGHNESS = clamp(roughness_base + (1.0 - texture(roughness_mask, UV).g) * 0.5, 0.0, 1.0);
	SPECULAR = 0.9;
	METALLIC = 0.0;
}
