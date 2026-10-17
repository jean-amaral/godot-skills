---
name: godot-csg-blockout
description: Blockout e prototipagem de nível com o plugin CSG Blockout (qwqzhanqwq/Godot-CSG-Blockout) na Godot 4.6+ — desenhar cômodos, cortar portas/janelas, formas CSG próprias do plugin, medir contra o personagem, checar o nível, Play From Here e congelar (freeze/unfreeze) em malha reversível. Use quando o projeto usa CSG Blockout e o criador pedir blockout, greybox, protótipo de nível/mapa, teste de escala de ambiente ou transformar blockout em malha.
---

# Godot CSG Blockout

Blockout é a pergunta "este espaço funciona?" respondida barato: **prototipar com CSG nativo, medir contra o personagem, jogar no espaço, e só então congelar ou modelar**. O lema do plugin é o contrato: *level prototyping, not modeling*.

Instalação: skill `godot-plugins-installer` (v3.1.0, Godot 4.6+). Construção CSG manual e bake clássico do pacote: `godot-3d-specialist` ([csg-construcao-e-bake.md](../godot-3d-specialist/references/csg-construcao-e-bake.md)) — esta skill é **operar o Blockout** e saber o que ele faz melhor que o CSG cru.

## O que o plugin muda (e o que não muda)

- Tudo que você constrói é **nó CSG comum da Godot** na árvore (`CSGBox3D`, `CSGCombiner3D`…): mover, redimensionar e apagar corte é editar nó, sem formato próprio trancado. Desligou o plugin, as primitivas ficam.
- O plugin adiciona ferramentas de editor (paleta no viewport, menu `Shift+A`), formas próprias e o **freeze reversível**: congela a árvore CSG em `MeshInstance3D` + colisão para rodar leve, guardando o CSG dentro do nó — **unfreeze devolve o CSG editável**. "Assado" nunca é "final".
- No export, o CSG guardado e os ajudantes de editor são removidos: o que vai para o jogo é malha comum.

## Fluxo de trabalho

1. **Métricas do jogador primeiro**: ajuste altura/pulo do personagem nas Project Settings do plugin (`addons/csg_blockout/player_metrics/*`) ou num `CSGPlayerReference3D`. Blockout medido contra o personagem errado é ficção.
2. **Desenhe o espaço**: ferramenta **Room** (arrastar o piso; parede/piso/altura nas settings `addons/csg_blockout/room/*`), **Door/Window** clicando na parede (tamanho em `addons/csg_blockout/openings/*`), formas e cortes arrastando. Grade única (0,125–8 m) para todas as ferramentas.
3. **Cheque**: **Check** marca rampa íngreme demais e teto abaixo da altura em pé/agachado; **Player Reference** mostra cápsula, altura de pulo e arco de pulo com corrida no viewport.
4. **Jogue no espaço**: **Play From Here** larga um personagem de teste em primeira pessoa onde você está olhando — sem mudar mapa de entrada nem autoload. Se não é divertido/andável aqui, não será com arte final.
5. **Congele ou promova**: espaço aprovado → **Freeze** (malha leve com colisão, reversível) ou exporte (MeshLibrary para `GridMap`, `.glb` para refinar no Blender e voltar). Não congele o que ainda está sendo desenhado.

Detalhe de ferramentas/formas/settings em [references/ferramentas-e-formas.md](references/ferramentas-e-formas.md); freeze/export/pipeline em [references/freeze-e-pipeline.md](references/freeze-e-pipeline.md).

## O que o agente faz (e o que é clique do criador)

- **Agente (código/MCP)**: criar e ajustar os nós que o plugin oferece — primitivas CSG e as classes próprias `CSGStairs3D`, `CSGArch3D`, `CSGCurvedWall3D`, `CSGWedge3D`, `CSGSpiralStairs3D`, `CSGRepeater3D`, `CSGSpreader3D`, `CSGPlayerReference3D` — via cena/script/`godot-ai-mcp` (`node_create`, `csg_manage`), e configurar as Project Settings do plugin. Via MCP, CSG genérico também nasce com `csg_manage` (`csg_create`, `csg_set_operation`).
- **Criador (editor)**: desenhar com a paleta/pie menu, arrastar setas de face, Play From Here e Freeze são gestos de viewport — o agente prepara a cena, orienta o gesto e confere o resultado (hierarquia/captura), não finge que arrastou.

## Regras

1. **Blockout não é arte final**: material de grade, proporção e fluxo primeiro; textura/modelo entram depois do espaço aprovado (aí `godot-visual-craft` e `godot-3d-specialist` assumem).
2. **Medida vem da métrica do pacote**: 1 unidade = 1 m, porta padrão 1,0 × 2,1 m (default do plugin), personagem 1,8 m — divergir é decisão registrada, não acidente.
3. **Freeze é marco, não rascunho**: congele ao aprovar o espaço; descongele para mudar. Nunca apague o CSG "porque já congelou" — a reversibilidade é o ponto.
4. **Repeater/Spreader são preview vivo**: antes de publicar a cena, **Bake** neles para virarem nós comuns (sem o plugin, preview não-assado não se sustenta).
5. **Tag semântica é dado de design**: marque parede/piso/perigo/interativo com as tags do plugin (material codificado por cor e metadado legível pelo jogo), não com nome solto na árvore.

## Arquivos desta skill

| Arquivo | Conteúdo |
|---|---|
| [references/ferramentas-e-formas.md](references/ferramentas-e-formas.md) | Ferramentas do viewport, formas próprias com parâmetros reais e Project Settings do plugin |
| [references/freeze-e-pipeline.md](references/freeze-e-pipeline.md) | Freeze/unfreeze, opções de bake, MeshLibrary, glTF round trip e o que sobrevive sem o plugin |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de mudanças da skill |
