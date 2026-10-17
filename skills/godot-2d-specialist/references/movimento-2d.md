# Movimento 2D (plataforma e top-down)

Sensação de controle é matemática com perdão embutido: números certos para o gênero + pequenas janelas que perdoam o jogador. Referência (jogo do gênero analisado quadro a quadro quando possível) define os números; esta folha define a estrutura.

## A ficha de movimento (antes do código)

| Número | Unidade | Como decidir |
|---|---|---|
| Tamanho do tile e do personagem | tiles | Personagem em tiles (ex.: 1×2) manda no vão e na porta do nível |
| Velocidade máxima (chão/ar) | tiles/s | Ritmo do gênero; correr × andar são dois números |
| Tempo até velocidade máxima / até parar | s | Aceleração alta = preciso; baixa = "gelado" (só se for o jogo) |
| Altura e tempo do pulo | tiles e s | Pulo projeta o nível: alcança N tiles, atravessa vão de M tiles |
| Gravidade subindo × caindo | tiles/s² | Cair mais rápido que subir é o padrão que "parece certo" |
| Dash | tiles, s, cooldown | Distância em tiles para o level design poder cobrar |

Valores moram num único lugar (constantes tipadas ou `Resource` do personagem) e a ficha preenchida fica em [templates/ficha-de-movimento.md](../templates/ficha-de-movimento.md).

## Plataforma: o kit de perdão (quase sempre todos)

- **Coyote time** (~0,08–0,12 s): pulou logo depois de sair da borda ainda vale. Sem ele, o jogo parece "comer input".
- **Jump buffer** (~0,1 s): apertou um pouco antes de pousar, o pulo sai ao tocar o chão (o buffer de entrada do pacote, `godot-3d-specialist/references/entrada-tween-audio.md`, é a mesma ideia).
- **Pulo variável**: soltou o botão, corta a subida (gravidade maior ou velocidade limitada) — pulo curto e pulo alto no mesmo botão.
- **Apex hang**: gravidade reduzida perto do topo do pulo dá controle fino onde o jogador mira o pouso. Sutileza: exagero vira "flutuar".
- **Snap ao chão e teto honesto**: `floor_snap_length` para descer rampa sem quicar; bater a cabeça encerra a subida sem grudar.
- **Um pulo duplo/dash muda o nível inteiro**: se existe, a ficha diz e o level design cobra (vão e altura projetados para quem tem — e portão para quem não tem).

Dash: distância/tempo/cooldown em tiles, com estado próprio (sem gravidade durante, se for o desenho), i-frames só se o design disser (dash ofensivo × evasivo são sistemas diferentes).

Escada/corda: estado próprio que desliga gravidade, com entrada/saída por área marcada (dado customizado do tile ou `Area2D`), nunca por "encostou no sprite".

## Top-down: outro contrato

- Sem gravidade: aceleração/atrito simétricos, 8 direções com diagonal **normalizada** (diagonal mais rápida é bug clássico).
- Mira e corpo podem ter donos diferentes (mouse gira a mira, corpo anda) — defina qual manda na animação.
- Dodge/roll: distância em tiles, i-frames declarados, cooldown visível para o jogador (HUD, skill `godot-ui-ux`).
- Separação entre corpos (`move_and_slide` + camadas) para inimigos não se empilharem num ponto só.

## Implementação (padrões do pacote)

- `CharacterBody2D` em `_physics_process`, `velocity` por eixo, `move_and_slide()` ao fim; `up_direction` certo antes de confiar em `is_on_floor()`.
- Estados nomeados (Idle/Run/Air/Dash/Hurt/Climb) com a máquina de estados do pacote; transição por condição testável, timer de coyote/buffer como variáveis do estado, não espalhadas.
- Leitura de entrada por ações do `InputMap` (nunca tecla crua), com buffer onde o gênero pede resposta.

## Verificação (números, não sensação)

1. Pulo máximo medido em tiles contra o projetado; vão máximo idem.
2. Coyote/buffer testados apertando "errado de propósito" no limite da janela.
3. Quina interna/externa, rampa e plataforma fina: sem prender, sem atravessar, sem quicar.
4. Velocidade e estado impressos (debug) durante o teste — sprite bonito esconde velocidade errada.

---
_Orientação revisada em 2026-10-17 para Godot 4.7+. Números de partida vêm da referência do gênero analisada, não desta folha: ela manda a estrutura e a medição._
