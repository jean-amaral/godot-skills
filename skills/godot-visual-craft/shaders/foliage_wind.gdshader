shader_type spatial;
render_mode cull_disabled, specular_schlick_ggx;

// Folhagem com vento: base presa, ponta livre (peso pela altura local),
// rajada lenta + tremida rapida, fase por posicao no mundo (nao em bloco).
uniform sampler2D albedo_texture : source_color, repeat_enable;
uniform float plant_height : hint_range(0.1, 4.0) = 1.0;
uniform float wind_strength : hint_range(0.0, 0.5) = 0.08;
uniform float wind_speed : hint_range(0.1, 4.0) = 1.2;
uniform float alpha_scissor : hint_range(0.0, 1.0) = 0.45;

void vertex() {
	vec3 world_origin = (MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
	float weight = clamp(VERTEX.y / plant_height, 0.0, 1.0);
	weight = weight * weight;
	float phase = world_origin.x * 0.35 + world_origin.z * 0.27;
	float gust = sin(TIME * wind_speed + phase) * 0.7;
	float flutter = sin(TIME * wind_speed * 3.7 + phase * 2.0 + VERTEX.y * 3.0) * 0.3;
	float bend = (gust + flutter) * wind_strength * weight;
	VERTEX.x += bend;
	VERTEX.z += bend * 0.6;
}

void fragment() {
	vec4 tex = texture(albedo_texture, UV);
	if (tex.a < alpha_scissor) {
		discard;
	}
	ALBEDO = tex.rgb;
	ROUGHNESS = 0.9;
	SPECULAR = 0.25;
}
