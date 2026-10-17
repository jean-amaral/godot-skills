# Física e colisão 2D

Física 2D justa: o jogador entende por que encostou, por que tomou dano e por que atravessou. Previsibilidade vale mais que realismo aqui.

## Camadas e máscaras por papel

Nomeie as camadas no projeto (Projeto → Física 2D) e monte a matriz antes das cenas:

| Camada (exemplo) | Colide com | É detectada por |
|---|---|---|
| Mundo/Terreno | Personagens, corpos | Consultas de chão/parede |
| Jogador | Mundo, perigo (via hurtbox) | Inimigos, coletáveis, triggers |
| Inimigo | Mundo, jogador (via hitbox dele) | Ataques do jogador |
| Ataque (hitbox) | — (é área) | Hurtboxes do outro lado |
| Coletável/Trigger | — (é área) | Jogador |

- Corpo (`CharacterBody2D`/`RigidBody2D`) resolve movimento; `Area2D` **detecta** — ataque, dano, coleta e gatilho são áreas com monitoramento ligado só na janela em que valem.
- Hitbox × hurtbox: quem ataca liga a hitbox por frames definidos (dados da animação/estado); quem recebe tem a hurtbox e o componente de vida (o `HealthComponent` do pacote, agnóstico de dimensão, com i-frames).

## Consultas e projéteis

- Chão/parede/alvo: `RayCast2D`/`ShapeCast2D` ou consulta direta ao espaço (`PhysicsRayQueryParameters2D`) com máscara certa — consulta sem máscara acerta o próprio dono (erro clássico).
- Projétil rápido é consulta por passo ou forma alongada, não sprite fino em alta velocidade (atravessa o alvo entre frames). Pooling de projéteis/inimigos frequentes: instanciar/destruir em rajada é o gargalo clássico 2D (padrão de pool do pacote).
- `RigidBody2D` é para o que a física manda (empilhamento, queda); gameplay preciso (personagem, projétil dirigido) é corpo cinemático com movimento próprio — física realista onde o jogador precisa de previsibilidade vira frustração.

## Justiça de colisão

- Caixa do personagem **menor que o desenho** (perdoa quina e teto); caixa de perigo também menor que o visual ameaçador. Dano que "pegou sem encostar" destrói confiança no jogo.
- One-way (plataforma que atravessa por baixo): forma/plataforma de mão única + cair através dela é ação desenhada (baixo + pular), não acidente de máscara.
- Sem escalar corpo físico: tamanho muda em `shape`/desenho, nunca em `CollisionObject2D.scale` (regra do pacote, vale em 2D igual).

## Erros clássicos

- Tudo na camada 1 colidindo com tudo: o coletável empurra o jogador, o trigger bloqueia a porta.
- Monitoramento de área ligado para sempre "para garantir" (custo e evento duplicado).
- Dano aplicado por contato de corpos em vez de hitbox com janela: dano por frame, sem i-frames.
- Projétil fino e rápido sem consulta: "atravessou o inimigo".

---
_Orientação revisada em 2026-10-17 para Godot 4.7+. Matriz de camadas é exemplo de partida: nomeie pelas funções do seu jogo._
