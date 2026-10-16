# Importação Blender/glTF e pós-importação

Falta o asset? A busca e o download de assets **gratuitos com licença verificada (CC0/CC-BY)** são da skill companheira `godot-free-assets`: ela busca nas fontes, apresenta para confirmação e baixa com manifesto e créditos. Aqui, cuidamos do que chega.

## Formato e preparo no Blender

- Exporte **`.glb`** (glTF binário): um arquivo só, sem textura solta para se perder.
- Aplique transformações de escala/rotação no Blender (Ctrl+A) antes de exportar; unidade em metros.
- Origem do objeto na base para props de chão (ver [metricas-e-alinhamento.md](metricas-e-alinhamento.md)).
- Nomeie malhas com os sufixos abaixo quando o comportamento for por malha.

## Sufixos de importação da Godot (por nome de nó/malha)

| Sufixo | Efeito na importação |
|---|---|
| `-col` | Mantém a malha e cria `StaticBody3D` + colisor |
| `-colonly` | Só colisor, malha não renderiza (colisor invisível) |
| `-convcol` / `-convcolonly` | Idem, com forma convexa em vez de côncava |
| `-occ` | Mantém a malha e gera `OccluderInstance3D` |
| `-occonly` | Só o oclusor, sem renderizar |
| `-navmesh` | Malha usada como fonte de navegação |
| `-noimp` | Nó ignorado na importação (auxiliares, guias) |

Colisor côncavo (`-col`) serve para estático. Corpo que se move usa convexo ou primitivas — côncavo dinâmico é caro e instável no Jolt.

A importação **remove o sufixo do nome do nó**: `Wall-col` chega à cena como `Wall` (com `StaticBody3D` filho), `Ghost-colonly` vira o próprio `StaticBody3D` sem malha, e `-occ` gera um `OccluderInstance3D` na cena. Não procure o nome com sufixo em runtime — verificado na 4.7.2 pela suíte `tests/`.

## `EditorScenePostImport` — o que o sufixo não cobre

Arquivo pronto para adaptar: [../scripts/scene_post_import.gd](../scripts/scene_post_import.gd). Os efeitos dos sufixos são testados num `.glb` gerado pela suíte `tests/`.

Use script de pós-importação (aba Import → Script) para regras do projeto, por exemplo:

- Gerar UV2 e marcar `meshes/light_baking` para props que recebem lightmap.
- Ligar geração de LOD em malhas arquitetônicas grandes.
- Renomear/padronizar nós e aplicar material padrão do projeto.

```gdscript
@tool
extends EditorScenePostImport

func _post_import(scene: Node) -> Node:
	_iterate(scene)
	return scene

func _iterate(node: Node) -> void:
	if node is MeshInstance3D:
		var mi := node as MeshInstance3D
		if mi.mesh != null and mi.name.ends_with("_arch"):
			mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	for child: Node in node.get_children():
		_iterate(child)
```

Depois de mudar o script de pós-importação, reimporte: clique direito no asset → **Reimportar**, ou `godot --headless --import --quit` no terminal.

## Armadilhas

- Escala 100× ou 0,01× na chegada = unidade errada no export (cm vs m). Corrija no Blender, não escalando o corpo físico na Godot.
- Malha "deitada" (Z-up vs Y-up): o glTF já converte para Y-up; se veio errado, é FBX/`.blend` direto com eixo trocado.
- Textura rosada/ausente: caminho externo quebrado no `.gltf` de texto — outro motivo para preferir `.glb`.
- `.blend` importado direto exige Blender instalado e configurado no editor; em CI headless, prefira `.glb` versionado.


---

_Última verificação: 2026-10-16, Godot 4.7.2 (suíte `tests/`). Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
