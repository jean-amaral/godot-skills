@tool
class_name PbrMaterialBuilder
extends RefCounted

## Monta StandardMaterial3D realista a partir de mapas baixados
## (pacote godot-free-assets: albedo, normal GL, roughness, AO/metallic).
## Copie para res://scripts/tools/. Salve o resultado UMA vez como .tres
## em res://resources/materials/ e compartilhe entre as peças do mesmo papel.

## Cria o material. Mapas nulos são ignorados (material nasce válido só com
## albedo). uv_scale = repetições por unidade do UV (parede: textura 2 m
## significa uv_scale 0.5 quando o UV cobre a peça inteira — ajuste à fonte).
static func create_material(
		albedo: Texture2D,
		normal_map: Texture2D = null,
		roughness_map: Texture2D = null,
		ao_map: Texture2D = null,
		uv_scale: float = 1.0,
		triplanar: bool = false) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	if albedo != null:
		material.albedo_texture = albedo
	if normal_map != null:
		material.normal_enabled = true
		material.normal_texture = normal_map
	if roughness_map != null:
		# Mapas empacotados tipo ambientCG/Poly Haven: roughness no canal G.
		material.roughness_texture = roughness_map
		material.roughness_texture_channel = BaseMaterial3D.TEXTURE_CHANNEL_GREEN
	if ao_map != null:
		material.ao_enabled = true
		material.ao_texture = ao_map
		material.ao_texture_channel = BaseMaterial3D.TEXTURE_CHANNEL_RED
	material.uv1_scale = Vector3(uv_scale, uv_scale, 1.0)
	if triplanar:
		material.uv1_triplanar = true
	return material

## Salva o material como .tres reutilizável. Retorna OK ou o erro.
static func save_material(material: StandardMaterial3D, resource_path: String) -> Error:
	if not resource_path.begins_with("res://"):
		return ERR_INVALID_PARAMETER
	DirAccess.make_dir_recursive_absolute(
		ProjectSettings.globalize_path(resource_path.get_base_dir()))
	return ResourceSaver.save(material, resource_path)
