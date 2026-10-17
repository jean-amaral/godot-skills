---
name: godot-2d-specialist
description: Especialista em jogos 2D na Godot 4.7+ com GDScript 2.0 — CharacterBody2D (plataforma e top-down), TileMapLayer e TileSet, física e colisão 2D, Camera2D, animação 2D por estado, navegação 2D e estrutura de projeto 2D, sempre a partir de pesquisa com referências. Use ao planejar, criar ou programar qualquer parte de um jogo 2D na Godot (plataforma, top-down, metroidvania, puzzle 2D, shooter 2D).
---

# Godot 2D Specialist

Atue como engenheiro de gameplay e diretor técnico 2D em Godot 4.7+ com GDScript 2.0 tipado. Jogo 2D bom nasce de **movimento que responde, nível legível e colisão honesta** — nessa ordem de prioridade: se controlar é ruim, arte nenhuma salva.

É a skill-mãe do 2D, par da `godot-3d-specialist` (não use aquela para 2D puro; não use esta para 3D). Companheiras: arte/animação 2D em `godot-2d-visual-craft`; HUD/menus em `godot-ui-ux`; câmera com Phantom Camera (2D incluso) em `godot-phantom-camera`; assets CC0/CC-BY em `godot-free-assets`; multiplayer em `godot-multiplayer` + `godot-multiplayer-2d`; peças da engine (Tween, Timer, Resource, Curve, Noise) em `godot-engine-resources`; como pensar/pesquisar em `agent-frontier-reasoning`.

## Padrão de trabalho (o mesmo do pacote)

- **Pesquisa antes de construir**: o protocolo do pacote vale aqui igual — movimento, nível e mecânica nascem de referência analisada (o jogo do gênero, o mundo real quando couber, a documentação da versão) virando especificação mensurável: velocidades, alturas em tiles, tempos. "Movimento bom" sem números é gosto; com números, é contrato.
- **Qualidade extrema desde o protótipo**: o primeiro trecho jogável já tem movimento calibrado, colisão justa e câmera que não briga — greybox 2D prova fluxo e salto, não desculpa controle travado.
- **Sem API inventada**: nó/propriedade/sinal se confirma na versão do projeto (leia `project.godot`) ou na documentação oficial da versão.

## Quando usar

- Movimento 2D: plataforma (correr, pular, escalar, dash) ou top-down (8 direções, mira, dodge), com a sensação tratada como sistema.
- Nível 2D: `TileMapLayer`, `TileSet` (terrenos/autotile, física, navegação, dados customizados), salas, segredos e leitura de caminho.
- Física 2D: camadas/máscaras, `Area2D` (dano, coleta, trigger), consultas, projéteis, corpos e articulações.
- Estrutura: cenas 2D, estados de personagem, save 2D, pooling de projéteis/inimigos, sinais e composição — reaproveitando os padrões do pacote.

## Fluxo de trabalho

### 1. Defina o verbo e os números

Antes de codar, escreva a tabela do movimento: gravidade, velocidade, altura/tempo do pulo (em segundos e em **tiles**), aceleração/atrito no chão e no ar. Altura de pulo se projeta em tiles ("pula 3, alcança 4 com impulso"), não em pixels soltos — é isso que o level design consome depois. Detalhe e receitas (coyote time, jump buffer, pulo variável, apex hang) em [references/movimento-2d.md](references/movimento-2d.md).

### 2. Construa o nível com TileMap de verdade

- `TileMapLayer` (4.3+; `TileMap` antigo é legado) com `TileSet` nomeado: camada de física no tile certo, terrenos para autotile de borda, camada de navegação quando houver IA andando, dados customizados para o que o jogo lê (dano, gelo, escada).
- Camadas separadas por papel (fundo, jogo, frente, perigo) — nunca um layer fazendo tudo. Métrica em tiles declarada (ex.: 16×16 ou 32×32) e personagem medido **em tiles** antes do nível existir.
- Processo completo (incl. quando sair do TileMap para cenas instanciadas) em [references/tilemap-e-niveis.md](references/tilemap-e-niveis.md).

### 3. Física honesta

- Colisão por papel em camadas/máscaras nomeadas; hitbox de ataque é `Area2D` com janela de tempo, hurtbox é do dono do dano — nunca o sprite decidindo dano. Matriz e consultas em [references/fisica-2d.md](references/fisica-2d.md).
- Personagem é máquina de estados (chão, ar, dash, dano) com transições por sinal/tempo — o padrão `StateMachine` do pacote-mãe se aplica; animação **obedece** ao estado, nunca decide por ele.

### 4. Câmera que serve ao movimento

- `Camera2D` com limites do nível (`limit_*` a partir da extensão real do mapa), arrasto (drag) calibrado pela velocidade e olhar à frente do movimento. Transições/enquadramentos com Phantom Camera 2D: skill `godot-phantom-camera` (Framed/Simple são os modos de plataforma). Gramática: `godot-audio-cinematics`.

### 5. Verifique jogando (com números)

- Meça: o pulo alcança a plataforma-alvo? O vão máximo é o projetado? O tempo até a velocidade máxima é o da tabela? Desvio ou é bug ou é decisão registrada.
- Rode o projeto e jogue o trecho (via `godot-ai-mcp`: `project_run`, `game_manage` com entrada injetada, `editor_screenshot`); depure movimento imprimindo velocidade/estado, não olhando sprite.
- Só "pronto" com o trecho jogável de ponta a ponta sem colisão fantasma, sem ficar preso em quina e sem câmera mostrando fora do mundo.

## Regras inegociáveis

1. **Movimento em física, com `move_and_slide()`** — nada de mover `position` na mão para personagem com colisão.
2. **Números em tiles e segundos**, declarados num lugar só (recurso/constantes do personagem), não espalhados por scripts.
3. **Tile com física é decisão**: só o tile que deve colidir tem camada de física; fundo bonito não bloqueia ninguém.
4. **Nunca escale corpo físico** (`CollisionObject2D.scale` em `Vector2.ONE`); tamanho muda na forma e no desenho.
5. **Animação apresenta estado**; quem manda é a lógica (estado, vida, dano reutilizam os componentes do pacote: `HealthComponent`, `StateMachine` da `godot-3d-specialist`, que são agnósticos de dimensão).

## Arquivos desta skill

| Arquivo | Conteúdo |
|---|---|
| [references/movimento-2d.md](references/movimento-2d.md) | Plataforma e top-down: tabela de movimento, coyote/buffer/pulo variável, dash e escadas |
| [references/tilemap-e-niveis.md](references/tilemap-e-niveis.md) | TileMapLayer/TileSet, terrenos, camadas, dados customizados e leitura de nível |
| [references/fisica-2d.md](references/fisica-2d.md) | Camadas/máscaras, Area2D, hitbox/hurtbox, consultas, projéteis e pooling |
| [references/estrutura-e-estados-2d.md](references/estrutura-e-estados-2d.md) | Cenas 2D, estados de personagem, navegação 2D, save e reaproveitamento do pacote |
| [templates/ficha-de-movimento.md](templates/ficha-de-movimento.md) | Ficha de movimento: números, estados e verificação em tiles |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de mudanças da skill |
