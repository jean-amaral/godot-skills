# Freeze, bake e pipeline (CSG Blockout 3.1)

## Freeze/unfreeze (o coração do plugin)

- **Freeze**: a árvore CSG vira `MeshInstance3D` com colisão, em **um passo de undo**; o CSG original fica guardado dentro do nó congelado. Rodar fica leve; editar continua possível.
- **Unfreeze**: devolve exatamente o CSG guardado. Scripts, grupos e filhos que você acrescentou ao nó congelado **sobrevivem** ao vai-e-volta — pode anexar gameplay ao blockout sem medo do unfreeze.
- **Rebake**: refaz a malha no lugar depois de mudar opções ou o CSG-fonte.
- **No export**: o CSG guardado e os ajudantes de editor são removidos (`addons/csg_blockout/bake/strip_source_on_export`, ligado por padrão) — o jogo publicado carrega malha comum, custo zero do plugin.

Quando congelar: espaço **aprovado jogando** (Play From Here + Check limpo). Congelar cedo demais transforma decisão de layout em discussão de malha; nunca congelar é deixar CSG pesado no build.

## Opções de bake por nó

- **Colisão**: nenhuma, trimesh, forma nativa por primitiva ou hull convexo — escolha pela função (piso/chão pedem precisão; volume decorativo pede barato).
- **Lightmap UV2**, **occluder** e **LODs** gerados no freeze para o blockout virar cenário de verdade sem retrabalho manual.
- Aviso de **não-manifold** em `CSGMesh3D`: malha aberta quebra CSG em silêncio na Godot; o inspetor do plugin aponta as arestas problemáticas. Malha sua no CSG só entra fechada.

## Saídas para produção

| Saída | Quando |
|---|---|
| Manter CSG (sem congelar) | Espaço ainda mudando toda semana |
| Freeze na cena | Espaço aprovado; nível roda como malha |
| **MeshLibrary** (`GridMap`) | Nível modular em grade; exportar de novo atualiza a biblioteca no lugar, com colisão e previews |
| **glTF round trip** | Congelado → `.glb` → refinar no Blender → trocar a malha refinada de volta; materiais Godot voltam **pelo nome** |

## O que sobrevive sem o plugin (a rede de segurança)

- Primitivas CSG nativas e formas próprias rebaixadas (`CSGPolygon3D`/`CSGMesh3D` equivalentes): intactas.
- Blockout congelado: `MeshInstance3D` + `StaticBody3D` comuns (só o unfreeze precisa do plugin).
- Materiais de grade moram na pasta do plugin: desativar mantém; **deletar a pasta** os remove — congele/publique antes de remover o plugin do projeto.
- Repeater/Spreader sem Bake são previews vivos dependentes do plugin: **asse antes** de remover/congelar a entrega.

## Relação com o resto do pacote

- `godot-3d-specialist` (CSG manual + bake clássico) continua valendo para arquitetura autoral no editor; o Blockout acelera a fase de **protótipo mensurável** antes dela.
- Espaço aprovado pelo Blockout vira construção modular/material/luz com `godot-visual-craft`; câmera do playtest com `godot-phantom-camera`; tudo dirigível pelo editor via `godot-ai-mcp`.

---
_Conferido em 2026-10-17 no repositório oficial (v3.1.0). Freeze se prova exportando: abra o build e confirme malha sem CSG guardado._
