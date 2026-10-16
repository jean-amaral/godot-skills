# Construção com CSG no editor e bake para malha estática

Caminho padrão para arquitetura (paredes, portas, janelas, salas) neste
pacote: **modela-se direto no editor com CSG, trava-se o layout e
converte-se (bake) para malha estática com material PBR realista**.
CSG é a ferramenta de construção e blocagem; malha assada é o que o jogo carrega.

## Montando a arquitetura com CSG

Organização: um `CSGCombiner3D` por cômodo/conjunto, filhos primitivos
nomeados pelo papel (`Wall_N`, `DoorCut`, `WindowCut`, `Slab`, `Column`).

| Peça | Receita |
|---|---|
| Parede | `CSGBox3D` com `size = (comprimento, altura, espessura)` na métrica do pacote (parede 3,0 m, espessura 0,2 m), pivô apoiado no piso |
| Porta | Filho `CSGBox3D` com operação **Subtraction**, `size = (1,0–1,2, 2,1–2,4, espessura + 0,04)`, atravessando a parede inteira |
| Janela | Subtraction menor, com peitoril: a caixa começa na altura do peitoril (ex.: 0,9 m), não no piso |
| Piso/teto | `CSGBox3D` achatado (espessura 0,1–0,2 m) em união com as paredes |
| Coluna/viga | `CSGBox3D`/`CSGCylinder3D` em união onde a parede encontra |
| Escada/rampa | Degraus em união ou `CSGPolygon3D` extrudado no perfil |

Regras que evitam artefato booleano:

- **Nunca deixe face coplanar**: o corte deve ultrapassar a parede dos dois
  lados (os `+0,04` acima). Faces exatamente no mesmo plano geram flicker e
  buraco que abre/fecha conforme o ângulo.
- Construa no grid do editor (snap de 0,25 m ou 0,1 m) e em múltiplos da
  métrica — CSG fora de medida vira retrabalho no bake.
- Material entra já no primitivo CSG (propriedade de material da forma):
  é ele que a malha assada carrega como superfície. Um material por papel
  (parede, piso, trim), não um por cômodo.
- Curvas e cilindros com segmentos sob controle: segmento é polígono no bake.

## Quando assar (bake) — e o que conferir

Asse quando o layout do cômodo travar (portas e vãos finais). CSG em
runtime recalcula booleano e sai caro em cena cheia; malha estática não.

**No editor:** selecione a forma raiz (`CSGCombiner3D`) e use o botão
**CSG → Bake Mesh Instance** da barra do viewport 3D: nasce um
`MeshInstance3D` irmão com a `ArrayMesh` assada. Por script/`@tool`, o
equivalente é `CSGShape3D.bake_static_mesh()` — empacotado e testado em
[../scripts/csg_baker.gd](../scripts/csg_baker.gd), que já cria a colisão.

Checklist pós-bake:

1. **Normais**: confira faces planas com a luz final. Se a versão da engine
   assar normal suavizada onde devia ser dura, a parede "derrete" na luz —
   corrija antes de espalhar o material (re-assar/ajustar) e registre no TDD.
2. **AABB e pivô**: a malha assada segue a regra do pacote (base no piso,
   medida conferida, ver [metricas-e-alinhamento.md](metricas-e-alinhamento.md)).
3. **Colisão**: parede reta usa forma primitiva barata (`BoxShape3D`) onde
   der; `create_trimesh_collision()`/côncava estática só onde a geometria
   pede (vão, escada). Corpo sempre sem escala — ver regra inegociável.
4. **Fonte preservada**: o combiner CSG é a fonte editável. Guarde-o numa
   cena `_source` separada (ou ramo oculto claramente nomeado); o nível
   jogável referencia as malhas assadas. Re-assar é barato; remodelar a
   partir da malha, não.
5. Rode o [auditor](../scripts/scene_auditor.gd) na cena resultante.

## Materiais realistas a partir de texturas baixadas

Textura realista vem da skill `godot-free-assets` (CC0/CC-BY, com crédito).
Com os mapas em mãos (albedo, normal, roughness, AO/metallic quando houver):

1. Crie o `StandardMaterial3D` com albedo (sRGB), normal **GL**, roughness
   no canal certo e escala de UV coerente com a métrica (textura de parede
   2 m × 2 m por repetição é um bom começo) — por script, use o testado
   [../scripts/pbr_material_builder.gd](../scripts/pbr_material_builder.gd);
   no editor, os mesmos campos no Inspector.
2. Para malha assada de CSG/arquitetura, **triplanar** (`uv1_triplanar`)
   salva parede sem UV caprichada: a textura projeta nos três eixos e a
   parede não estica. Pague o custo só onde precisa.
3. Salve o material como `.tres` em `res://resources/materials/` e aplique
   o mesmo recurso em todas as paredes do papel — material duplicado por
   parede é memória e inconsistência.
4. Aplique, capture com a luz final e compare com a referência
   (ver [pesquisa-e-referencias.md](pesquisa-e-referencias.md)).

---
_Referência revisada em 2026-10-16 (Godot 4.7.2). A suíte `tests/` prova os scripts do pacote; as receitas daqui são orientação de uso, não comportamento testado. Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
