# Materiais PBR e shaders-base

Complementa [iluminacao-e-estilo.md](iluminacao-e-estilo.md): lá é luz e estilo; aqui é superfície.

## Checklist StandardMaterial3D (PBR)

- Albedo sRGB; normal, roughness e metallic em espaço **linear** (importação marcada corretamente — textura de dado com sRGB ligado lava o material).
- Empacote ORM quando o asset trouxer: **O**cclusion no R, **R**oughness no G, **M**etallic no B de uma textura só; confira o canal no material, não presuma a ordem do pacote de origem.
- Metalness é quase sempre 0 ou 1; valor no meio é sujeira/dieletrico disfarçado e costuma ler como erro.
- Emissivo para o que brilha de verdade (tela, letreiro), com energia combinando com a luz falsa que o acompanha — emissivo sem luz correspondente parece adesivo.
- Triplanar em rocha/terreno sem UV decente; decal (`Decal`) para sujeira, dano e sinalização sem retrabalhar a malha.

## Material por instância sem vazamento

- Alterar material de **uma** instância duplicando o recurso inteiro por objeto vaza memória em cena cheia. Ordem de preferência:
  1. `instance uniform` de shader/parâmetro por instância quando só muda um valor (cor, dano).
  2. Material override na `MeshInstance3D` só daquela instância, recurso marcado `resource_local_to_scene` quando a cena instancia várias cópias.
  3. Duplicação explícita e contada (poucos heróis de cena).
- Hit-flash/dano: uniforme de flash no shader com decaimento no código, não troca de material por frame.

## Shaders-base que todo projeto 3D pede

| Efeito | Abordagem |
|---|---|
| Hit-flash | Uniforme `flash_amount` somando branco/vermelho, decaimento por tween ou tempo |
| Dissolve (morte/despawn) | Ruído × limiar com borda emissiva; descarte por `discard` |
| Outline/toon | Banda de luz + borda por normal invertida ou pós-processo, conforme o estilo já escolhido |
| Água/lava simples | Scroll de normal + fresnel; profundidade só se o orçamento permitir |
| Pós (vinheta, grade) | Shader de tela cheia no `WorldEnvironment`/camada, um passe só |

Regras: shader espacial com nome de uniforme estável e valor padrão seguro (sem o shader, o prop continua legível); efeito de tela cheia é um por vez até provar orçamento; pré-aqueça materiais de efeito no loading para não travar no primeiro uso.

## Validação visual

Material se aprova na cena com a luz final, de perto e de longe (mipmap estourando vira brilho nadando), e no pior caso de luzes da sala — não no preview isolado.

---
_Referência revisada em 2026-10-16 (Godot 4.7.2). A suíte `tests/` prova os scripts do pacote; as receitas daqui são orientação de uso, não comportamento testado. Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._

> Para shaders e materiais com acabamento alem do basico (camadas, desgaste, agua/vidro/terreno/folhagem), a skill companheira e `godot-visual-craft`.
