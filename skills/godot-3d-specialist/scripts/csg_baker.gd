@tool
class_name CsgBaker
extends Node

## Assa um CSGCombiner3D (forma raiz) para MeshInstance3D estático,
## com colisão côncava opcional. Equivalente por script ao botão
## "CSG -> Bake Mesh Instance" do editor. Copie para res://scripts/tools/.
##
## A forma CSG continua sendo a FONTE editável: guarde-a numa cena _source;
## o nível jogável usa a malha assada retornada aqui.

## Assa `root_shape` e devolve o MeshInstance3D criado como filho de
## `parent` (ou da cena editada, se parent for nulo). Retorna null sem
## malha válida (CSG fora da árvore ainda não calculado, por exemplo).
static func bake_to_mesh_instance(root_shape: CSGShape3D, parent: Node, mesh_name: String = "BakedMesh", with_collision: bool = true) -> MeshInstance3D:
	if root_shape == null:
		push_warning("CsgBaker: root_shape nulo.")
		return null
	var mesh: ArrayMesh = root_shape.bake_static_mesh()
	if mesh == null or mesh.get_surface_count() == 0:
		push_warning("CsgBaker: bake sem superfície (CSG calculado? forma dentro da árvore?).")
		return null
	var instance := MeshInstance3D.new()
	instance.name = mesh_name
	instance.mesh = mesh
	if parent != null:
		parent.add_child(instance)
	if with_collision:
		# StaticBody3D + ConcavePolygonShape3D sob a instância.
		instance.create_trimesh_collision()
	return instance
