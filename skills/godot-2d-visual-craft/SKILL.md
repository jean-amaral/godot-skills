---
name: godot-2d-visual-craft
description: Arte e animação 2D na Godot 4.7+ — pixel art e importação sem borrar, sprite sheets e animação por estado (AnimatedSprite2D/AnimationPlayer), arte de tileset, parallax, luz 2D e shaders CanvasItem, sempre a partir de pesquisa com referências. Use quando o criador pedir visual 2D, pixel art, animação de personagem 2D, tileset, fundo/parallax, iluminação 2D ou polimento visual de jogo 2D.
---

# Godot 2D Visual Craft

Visual 2D bom é **legibilidade em movimento**: o jogador lê personagem, perigo e caminho enquanto tudo se mexe. Pesquisa primeiro (referência analisada), pipeline limpo (importação certa), animação com peso — par da `godot-visual-craft` (3D) para o mundo 2D.

Movimento/gameplay 2D: `godot-2d-specialist`. HUD/menus: `godot-ui-ux`. Asset externo licenciado: `godot-free-assets` (nunca embuta referência estudada como asset).

## Protocolo de pesquisa (obrigatório, antes de desenhar)

1. **Referências do gênero/estilo contratado**: o jogo cuja leitura você admira — extraia paleta (hex), silhueta, quanto detalhe sobrevive em movimento, ritmo de animação (frames por ação) e como fundo/fora se separam.
2. **Especificação antes da arte**: tamanho de sprite/tile em pixels, paleta fechada, lista de animações por estado do personagem (a ficha de movimento da `godot-2d-specialist` diz quais estados existem) e orçamento de frames por animação.
3. **Comparação em movimento**: capture o personagem **jogando** ao lado da referência. Pose parada bonita que some em movimento é o fracasso clássico do 2D.

## Padrões por disciplina

### Pixel art e importação (onde metade dos visuais 2D morre)

- Importação para pixel art: filtro **desligado** (nearest), compressão sem perda, e projeto configurado para não suavizar — sprite que borra na importação não se salva com shader.
- Um tamanho-base declarado (tile/sprite em px) e escala por múltiplos inteiros quando o estilo pede; `snap` de posição para a grade de pixels em movimento evita o "nadar" do sprite.
- Fora do pixel art (arte pintada/HD 2D): filtro ligado é legítimo — a decisão é do estilo contratado, registrada, não do padrão da engine. Guia em [references/pixel-art-e-importacao.md](references/pixel-art-e-importacao.md).

### Animação 2D

- Animação é por **estado do personagem** (idle/run/jump/fall/attack/hurt): quem manda é a máquina de estados; o visual obedece e volta. `AnimatedSprite2D`/`SpriteFrames` para sprites por frames; `AnimationPlayer` quando a animação move mais que o sprite (posição, efeitos, chamadas de método/áudio nos marcos).
- Peso vem de tempo: antecipação, aceleração, squash & stretch com teto (deformação que muda a leitura da colisão confunde — a forma física nunca muda com o desenho). Ritmos e checklist em [references/sprite-e-animacao.md](references/sprite-e-animacao.md).
- Frames-chave primeiro (poses que contam a ação), depois intermediários. Animação "lisa" sem poses fortes é sopa.

### Tileset, fundo e parallax

- Tileset se desenha para o terreno/autotile funcionar: peças de borda/canto/quina pensadas como sistema, variação interna sem quebrar a grade, e contraste terreno × fundo que lê em velocidade. [references/tileset-e-parallax.md](references/tileset-e-parallax.md)
- Parallax por camadas com velocidades que contam profundidade (longe lento e menos contraste, perto rápido), sem camada competindo com o plano de jogo em contraste/saturação.

### Luz e shader 2D

- `PointLight2D`/`DirectionalLight2D` com texturas de luz, `LightOccluder2D` no que bloqueia, `CanvasModulate` para o clima da cena; mapa normal em sprite dá volume sob luz 2D quando o estilo pede.
- Shader `canvas_item` para efeitos (flash de dano, outline, dissolver, água 2D): parâmetro exposto com nome do mundo, custo declarado e o efeito legível **desligado** também (flash não pode ser a única informação do dano). Receitas e cuidados em [references/luz-e-shader-2d.md](references/luz-e-shader-2d.md).

## Verificação

- [ ] Sprite nítido na resolução de jogo (nada de borrão de importação) e sem "nadar" ao andar.
- [ ] Personagem/perigo/caminho legíveis em captura **em movimento**, na velocidade real.
- [ ] Toda animação da ficha de estados existe, entra e sai pelo estado certo.
- [ ] Flash/efeito desligado ainda comunica (cor/ícone/som redundantes).
- [ ] Comparação com a referência registrada: diferença corrigida ou decisão escrita.

## Arquivos desta skill

| Arquivo | Conteúdo |
|---|---|
| [references/pixel-art-e-importacao.md](references/pixel-art-e-importacao.md) | Importação pixel-perfect, escala, snap, paleta e os erros que borram sprite |
| [references/sprite-e-animacao.md](references/sprite-e-animacao.md) | SpriteFrames × AnimationPlayer, ritmos, squash & stretch e animação por estado |
| [references/tileset-e-parallax.md](references/tileset-e-parallax.md) | Arte de tileset para autotile, camadas de fundo e parallax legível |
| [references/luz-e-shader-2d.md](references/luz-e-shader-2d.md) | Light2D/occluders, CanvasModulate, normal 2D e shaders canvas_item |
| [templates/ficha-visual-2d.md](templates/ficha-visual-2d.md) | Ficha visual: tamanhos, paleta, animações por estado e verificação |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de mudanças da skill |
