---
name: godot-phantom-camera
description: Câmeras de jogo com o plugin Phantom Camera (ramokz/phantom-camera) na Godot 4.4+ — PhantomCameraHost e PhantomCamera2D/3D, prioridades e transições, modos de follow (Glued, Simple, Group, Path, Framed, Third Person), look-at, tween de câmera, ruído e camadas de host. Use quando o projeto usa (ou deve usar) Phantom Camera e o criador pedir câmera que segue, câmera de terceira pessoa, corte/transição de câmeras, enquadramento de grupo ou shake de câmera.
---

# Godot Phantom Camera

Câmera boa é direção invisível: o jogador olha para o jogo, não para a câmera. Com Phantom Camera, você **não anima `Camera3D` na mão** — você dirige câmeras virtuais (`PhantomCamera3D/2D`) e deixa o `PhantomCameraHost` mover a câmera real entre elas por prioridade, com tween.

Instalação do plugin: skill `godot-plugins-installer` (v0.11.0.3, Godot 4.4+). Direção/gramática de câmera (o que filmar): `godot-audio-cinematics`. Esta skill é **como operar o Phantom** sem lutar com ele.

## A arquitetura em 30 segundos

```
Camera3D (a câmera real, com um filho:)
└── PhantomCameraHost        ← move a Camera3D para a PCam ativa
PhantomCamera3D "Gameplay"   ← câmeras virtuais espalhadas pela cena
PhantomCamera3D "Boss"       ← quem tiver maior priority (ativa) vence
PhantomCameraManager         ← autoload do plugin: registro global de hosts/PCams
```

- **`PhantomCameraHost`** é filho da `Camera2D/3D` real (um host por câmera). Sem host, PCam não move câmera nenhuma — é o erro nº 1.
- **PCam ativa = a de maior `priority`** entre as visíveis na mesma camada de host (`host_layers`). Trocar prioridade é o corte/transição: o host interpola usando o `tween_resource` da PCam que está **entrando**.
- Ao ativar o plugin, o autoload `PhantomCameraManager` existe em qualquer script: `PhantomCameraManager.get_phantom_camera_3ds()`, `get_phantom_camera_hosts()`.

## Fluxo de trabalho

1. **Estruture**: câmera real + host; uma PCam por intenção (gameplay, diálogo, área, chefe) — não uma PCam fazendo tudo com script trocando alvo a cada fase.
2. **Escolha o follow** pelo comportamento (tabela abaixo), alvo, damping e offset — nessa ordem. Follow errado com damping bonito continua errado.
3. **Transições por prioridade**: gameplay muda `priority` (código: `set_priority()`), cutscene usa PCams dedicadas; conecte `became_active`/`became_inactive` para ligar/desligar o que a câmera acompanha (controle, HUD, áudio).
4. **Verifique jogando**: transição no contexto real (velocidade do personagem, colisão de câmera, troca rápida de prioridade), não na cena parada. Via `godot-ai-mcp`: `editor_screenshot` do viewport/`game` e `project_run` para provar.

## Modos de follow (3D e 2D; Third Person só 3D)

| Modo | Comportamento | Use para |
|---|---|---|
| `NONE` | PCam fixa; só posição/rotação dela | Câmera de ambiente, diálogo, puzzle |
| `GLUED` | Cola no alvo (herda posição) | Acompanhar plataforma/elevador |
| `SIMPLE` | Segue com `follow_offset` e damping opcional | O follow padrão de gameplay |
| `GROUP` | Segue o centro de `follow_targets`, reenquadra para caber todos | Co-op local, escolta, arena |
| `PATH` | Segue o alvo preso ao `follow_path` (`Path3D/2D`) | Trilho, corredor, câmera de apresentação |
| `FRAMED` | Zona morta (`dead_zone_width/height`): só segue quando o alvo tenta sair do quadro | Plataforma, exploração com respiro |
| `THIRD_PERSON` | Orbita o alvo com `follow_distance`, `spring_length` e colisão (`collision_mask`, `margin`) | Terceira pessoa (o controle gira a PCam; ela resolve o resto) |

Look-at é independente do follow: `look_at_mode` `NONE/MIMIC/SIMPLE/GROUP` com `look_at_target(s)`, `look_at_offset`, damping e lookahead próprios. Seguir um nó e olhar para outro é o caso normal.

Detalhe de parâmetros (damping por eixo, lookahead, trava de eixo, distância automática, limites 2D) em [references/follow-e-transicoes.md](references/follow-e-transicoes.md). Receitas prontas (terceira pessoa, grupo, cutscene por prioridade, shake) em [references/receitas-de-camera.md](references/receitas-de-camera.md).

## Regras que evitam a briga clássica

1. **Um dono por câmera**: ou o host move a `Camera3D`, ou o seu script move — nunca os dois. Script de câmera próprio + Phantom no mesmo projeto é migrar ou remover um.
2. **Prioridade é estado, não evento**: quem entra sobe a prioridade e quem sai **restaura** a anterior (sinais `became_active/inactive` ajudam). Prioridade esquecida alta é a câmera "presa" de todo bug report.
3. **Tween de quem entra**: duração/transição/ease vêm do `PhantomCameraTween` da PCam nova (`set_tween_duration/transition/ease`); para sequências dirigidas, `PhantomCameraTweenDirector` sobrepõe o tween por par origem→destino.
4. **Teleporte não faz tween**: reposicionou PCam/alvo de forma brusca, chame `teleport_position()` — senão a câmera atravessa o cenário deslizando.
5. **Shake é ruído, não tween**: `PhantomCameraNoise3D/2D` na PCam + `PhantomCameraNoiseEmitter3D/2D` disparando (ou `emit_noise()`), com camada de emissor casando com `noise_emitter_layer` da PCam. Tremor no transform da câmera real briga com o host.
6. **Host layers isolam mundos**: PCam e host só se enxergam na mesma `host_layers` — use para câmera de menu/mundo separados sem briga de prioridade; PCam fora da camada do host é PCam muda (e parece bug).

## Com o Godot AI (MCP)

As PCams são nós comuns para o `godot-ai-mcp`: crie/ajuste com `node_create`/`node_set_property` (`priority`, `follow_mode`, alvos por caminho), leia com `node_get_properties`, prove com `project_run` + `editor_screenshot`. Ordem segura: hierarquia primeiro (`scene_get_hierarchy`), propriedades depois, rodar por último — câmera se julga em movimento.

## Arquivos desta skill

| Arquivo | Conteúdo |
|---|---|
| [references/follow-e-transicoes.md](references/follow-e-transicoes.md) | Follow/look-at em detalhe, damping, lookahead, prioridades, tween e camadas de host |
| [references/receitas-de-camera.md](references/receitas-de-camera.md) | Receitas: terceira pessoa, follow de gameplay, grupo, cutscene por prioridade e shake |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de mudanças da skill |
