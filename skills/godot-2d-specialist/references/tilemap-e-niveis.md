# TileMap e níveis 2D

Nível 2D legível se constrói em camadas com papéis separados e tiles que sabem o que são. `TileMapLayer` é a ferramenta (Godot 4.3+); `TileMap` antigo é legado de projeto velho, não escolha nova.

## Estrutura que funciona

```
Level (Node2D)
├── Background (TileMapLayer - sem física, parallax distante fica fora, na arte)
├── Terrain (TileMapLayer - física, terrenos/autotile)
├── Hazards (TileMapLayer ou cenas - dano por Area2D/dado customizado)
├── Foreground (TileMapLayer - sem física, passa na frente)
└── Actors (jogador, inimigos, itens como cenas)
```

- **Uma camada, um papel**: fundo não colide, terreno colide, frente não bloqueia. Misturar papéis num layer só é a origem de "piso bonito que prende o jogador".
- **Ator é cena, não tile**: o que anda, ataca ou se coleta nasce como cena instanciada sobre o mapa — tile é cenário.

## TileSet bem montado

- **Terrenos (autotile)** para borda de plataforma/chão: desenhe o miolo e deixe o terreno resolver a borda; pintar borda na mão em nível grande é retrabalho garantido.
- **Física por tile**, só onde colide: forma do tile acompanha o desenho (meio-tile inclinado é forma própria, não caixa inteira disfarçada).
- **Camada de navegação** no TileSet quando houver IA andando pelo mapa (o agente de navegação 2D lê daí); sem IA de chão, não pague o custo.
- **Dados customizados** para o que o jogo lê do tile: `tipo` (gelo, escada, espinho), dano, som de passo. Dado no tile > área invisível desenhada por cima para a mesma função.
- **Fonte de tile é arte com contrato**: tamanho de célula único no projeto, atlas organizado e revisado pela skill `godot-2d-visual-craft` (importação pixel-perfect mora lá).

## Leitura de nível (o design sobre o mapa)

- Caminho principal se lê sem mapa: contraste de terreno, luz e marcos (a gramática visual da referência do gênero) — se o jogador precisa de seta para o óbvio, o nível não está dizendo.
- Ensinar antes de cobrar: mecânica nova aparece em espaço seguro, depois combinada, depois cobrada (o onboarding contextual de `godot-ui-ux` aplicado ao espaço).
- Segredo é desvio visível para quem olha (parede diferente, vão sugestivo), não pixel caçado sem pista.
- Métrica manda: porta, vão e teto em tiles a partir da ficha de movimento (pulo alcança N, dash atravessa M) — nível desenhado "no olho" quebra na primeira calibragem do personagem.

## Quando sair do TileMap

- Formas orgânicas/diagonais complexas, salas com geometria única: cena com `StaticBody2D`/`CollisionPolygon2D` ou composição de peças — tilemap é grade, não force a grade a fingir curva.
- Repetição modular grande (fases geradas): instanciar salas-cena com âncoras de conexão continua sendo "nível em grade", com salas no lugar de tiles.

## Erros clássicos

- `TileMap` (legado) em projeto novo; tile de fundo com física "porque já estava no TileSet".
- Dois tamanhos de célula no mesmo projeto sem conversão declarada.
- Perigo mortal indistinguível do cenário (leitura antes de punição).
- Nível inteiro num layer só, impossível de ajustar sem redesenhar tudo.

---
_Orientação revisada em 2026-10-17 para Godot 4.7+ (`TileMapLayer`). Confira propriedades na documentação da versão do projeto antes de aplicar._
