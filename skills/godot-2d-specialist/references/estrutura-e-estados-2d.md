# Estrutura, estados e sistemas 2D

O 2D reaproveita quase toda a fundação do pacote — o que muda é a geometria, não a arquitetura.

## Cenas e composição

- Ator = cena composta (corpo + forma + sprite/animação + componentes), sistema = nó ou recurso, dado = `Resource` tipado. Sinal para cima, chamada para baixo (o padrão de arquitetura da `godot-3d-specialist`).
- Vida/dano: `HealthComponent` do pacote-mãe (sinais, i-frames, morte/revive) — não reescreva para 2D.
- Estados de personagem/inimigo: a `StateMachine` do pacote (guards e histórico) serve igual; estados 2D típicos: chão/ar/dash/escalada/dano para o jogador; patrulha/perseguição/ataque para o inimigo com percepção por `Area2D`/raycast.

## Navegação 2D

- IA que anda pelo chão/mapa: `NavigationAgent2D` + região de navegação (do TileSet ou `NavigationRegion2D`), com alvo e desvio tratados como no 3D (skill-mãe, referência de navegação) — em plataforma, navegação é por links/pontos, e muitas vezes máquina de estados com raycasts resolve melhor que malha. Escolha pelo mapa, não pelo hábito.
- Inimigo de plataforma clássico (anda-e-volta, persegue no mesmo andar) é estado + sensores (chão à frente, parede), sem navegação: mais previsível e mais barato.

## Save, spawn e persistência

- Save em JSON validado campo a campo (o contrato e o `SaveSystem` do pacote se aplicam; posição/estado 2D são só dados menores). Nada de salvar `.tres` vindo de `user://`.
- Respawn/spawn por marcadores nomeados na cena (`Marker2D`), checkpooint como estado salvo — nunca posição mágica escrita no script do nível.
- Carregamento de cena/transição segue o padrão do pacote (loader assíncrono quando a cena pesa; troca simples quando não pesa).

## Câmera 2D (resumo — detalhe nas companheiras)

- `Camera2D`: limites a partir da extensão do nível (`limit_*`), `drag` (margens de arrasto) pela velocidade, suavização com propósito (perseguir correndo ≠ contemplar parado).
- Phantom Camera 2D (`PhantomCamera2D` + host na `Camera2D`): Framed/Simple para gameplay com transições entre áreas — skill `godot-phantom-camera`.
- Múltiplas câmeras/split-screen são Viewports: decisão de design (skill `godot-ui-ux` para a experiência), não improviso de câmera.

## Plataforma de verificação

- Projeto importando e rodando sem erro; trecho jogável completo; movimento medido contra a ficha.
- Via MCP (`godot-ai-mcp`): `tilemap_manage`/`gridmap_manage` para células quando fizer sentido, `navigation_manage` para bake/caminho, entrada injetada no `game_manage` para provar o trecho sem depender do teclado.

---
_Orientação revisada em 2026-10-17 para Godot 4.7+. Fundação reaproveitada da `godot-3d-specialist` — divergência 2D é geometria e física, não padrão de código._
