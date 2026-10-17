# Luz 2D e shaders CanvasItem

Luz 2D é clima e leitura: diz onde é seguro, onde é fundo e que horas são no mundo. Efeito que esconde informação de gameplay é regressão bonita.

## Luz 2D (o sistema da engine)

- `PointLight2D` (com textura de luz radial/forme) e `DirectionalLight2D` (sol/lua) sobre `CanvasModulate` que define a luz-ambiente da cena. Cena noturna = modulate escuro + luzes locais, não sprites escurecidos um a um.
- `LightOccluder2D` no que deve bloquear luz (parede, porta): oclusor em tudo custa e borra sombra; só onde a sombra conta.
- **Mapa normal** no sprite (textura companheira) dá relevo sob luz 2D: vale para arte pintada e pixel art com disciplina (normal desenhado na mesma grade). Sem luz dinâmica na cena, normal é custo sem retorno.
- Energia/alcance de luz são direção de cena: poucas luzes fortes contam mais que muitas fracas; teste o custo no alvo (luz 2D em mobile é orçamento real).

## Shaders `canvas_item` (efeitos com contrato)

| Efeito | Uso típico | Cuidado |
|---|---|---|
| Flash branco/cor | Dano, coleta | Nunca a única informação do evento (some rápido, some para daltônico) |
| Outline | Alvo selecionado, interativo | Espessura em pixels do projeto, não da tela |
| Dissolver/ruído | Morte, spawn, portal | Legível no começo e no fim (nascer sumido confunde presença) |
| Ondulação/distorção | Água, calor, fantasma | Não distorça hitbox visual a ponto de mentir posição |
| Paleta trocada (swap) | Variações de inimigo/equipe | Paleta como dado, não shader copiado por cor |

Regras do pacote, iguais às do 3D: uniform com nome do mundo e valor seguro, custo declarado, efeito **desligado ainda comunica** (o estado existe sem o shader), e nada de efeito de tela cheia por padrão em hardware fraco sem alternativa.

## Clima por cena (sem retrabalho)

- Um "rig de clima" por bioma/horário: `CanvasModulate` + luzes-tipo + eventuais partículas 2D (`GPUParticles2D`/`CPUParticles2D` em 2D: chuva, poeira, folhas) — trocar o clima é trocar o rig, não editar 40 nós.
- Partícula 2D atrás e na frente do plano de jogo com presença diferente; partícula sobre o personagem compete com a leitura dele.

## Erros clássicos

- Escurecer sprite para fingir noite (quebra sob qualquer luz e em cada sprite novo).
- Flash de dano como único sinal (some no print, some para quem não distingue a cor).
- Oclusor em cada tile decorativo: sombra cara e tremida, ganho visual zero.

---
_Orientação revisada em 2026-10-17 para Godot 4.7+. Confira nós e propriedades na documentação da versão do projeto; efeitos se aprovam em captura em movimento._
