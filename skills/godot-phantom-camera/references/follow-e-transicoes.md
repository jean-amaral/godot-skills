# Follow, look-at e transições (Phantom Camera 0.11)

API conferida no código do plugin (`phantom_camera_3d.gd`/`phantom_camera_2d.gd`, v0.11.0.3). Propriedade existe aqui = existe na versão fixada; confira no `node_get_properties` antes de usar em outra versão.

## Follow em detalhe

- **Damping** (`follow_damping`, `follow_damping_value` por eixo): suaviza a perseguição. Valor é tempo de resposta por eixo — Y mais lento que XZ dá peso em plataforma; damping igual nos três eixos dá o "arrasto" clássico. Sem damping, `SIMPLE` é rígido como `GLUED` com offset.
- **Lookahead** (`follow_lookahead`, `follow_lookahead_time`, aceleração/deceleração, teto `follow_lookahead_max_value`): antecipa para onde o alvo está indo. Sem teto, alvo rápido arranca a câmera; com tempo alto demais, a câmera "foge" do alvo parado. Comece baixo (0.1 s) e suba jogando.
- **Trava de eixo** (`follow_axis_lock`): congela eixos do follow (ex.: câmera lateral que não sobe/desce com o pulo). Resolve em uma propriedade o que seria script de correção.
- **Distância automática** (`auto_follow_distance` + min/max/divisor, modos Group/Framed): a PCam se afasta/aproxima para manter os alvos no quadro. É o coração do co-op local sem split-screen.
- **Zona morta (Framed)**: `dead_zone_width/height` (0–1 da tela). O alvo se move livre dentro dela; a câmera só anda na borda (sinal `dead_zone_reached`). Dead zone grande em jogo rápido = alvo some na borda: dimensione pela velocidade do personagem.
- **Third Person**: `follow_distance` (distância-alvo), `spring_length` (comprimento do braço com colisão), `collision_mask` e `margin` resolvem a parede atrás; `shape` customiza o ShapeCast. Quem gira é o seu controle (rotação da PCam); quem não atravessa parede é o spring.
- **Alvo físico**: alvo que é corpo físico pode pedir processamento em física — a PCam expõe `physics_target_changed`; trepidação (jitter) com alvo em física geralmente é follow em processo visual brigando com física: alinhe quem atualiza (dica do próprio plugin: Project Settings `phantom_camera/tips/show_jitter_tips`).

## Look-at em detalhe

- `MIMIC` copia a rotação do alvo (cockpit, câmera em veículo); `SIMPLE` mira o alvo (+ `look_at_offset` para não mirar no pé); `GROUP` mira o centro dos `look_at_targets`.
- Damping e lookahead de olhar são independentes dos de follow — olhar costuma pedir resposta mais rápida que a posição.
- `up`/`up_target` definem o "para cima" da mira (gravidade variável, naves); padrão `Vector3.UP`.

## Prioridades e transição

- PCam ativa = maior `priority` visível na mesma `host_layers`. Empate/ausência = nenhuma transição mágica: defina prioridades distintas por intenção (ex.: gameplay 10, diálogo 20, chefe 30, cutscene 40) e documente a escala no projeto.
- `priority_override` força esta PCam acima de todas enquanto verdadeiro — ferramenta de cutscene/debug, não de gameplay permanente.
- A transição usa o **tween da PCam que entra**: `PhantomCameraTween` (`duration`, `transition`, `ease` — os enums são os do `Tween` da Godot). `tween_on_load=false` evita voo de câmera na entrada da cena.
- Sinais para reagir: `became_active`, `became_inactive`, `tween_started`, `tween_completed`, `tween_interrupted` (outra PCam cortou no meio) no PCam; `pcam_became_active/inactive` no host.
- `PhantomCameraTweenDirector` + `TweenDirectorResource`: tween específico por par (de X para Y), para a transição-assinatura (ex.: sempre lenta entrando no chefe, sempre corte seco saindo).
- Múltiplos hosts (câmera de jogo + câmera de retrato/menu): cada câmera real tem seu host; `host_layers` separa quais PCams cada um enxerga. `inactive_update_mode` controla se PCam inativa continua seguindo (custo × prontidão da transição).

## Erros clássicos

- PCam sem host (ou host em outra `host_layers`): "adicionei a PCam e nada acontece".
- Duas câmeras reais ativas disputando: host não substitui `current` da câmera — uma câmera real por vez é o desenho.
- Prioridade de cutscene nunca restaurada: o jogo "perde" a câmera de gameplay.
- Damping como remédio para follow errado: primeiro o modo, depois o amortecimento.

---
_API conferida em 2026-10-17 no repositório oficial `ramokz/phantom-camera` (v0.11.0.3). Documentação completa: [phantom-camera.dev](https://phantom-camera.dev/)._
