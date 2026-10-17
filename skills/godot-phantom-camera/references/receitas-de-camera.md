# Receitas de câmera (Phantom Camera)

Estruturas de nós e valores de partida — ajuste jogando, com a gramática de `godot-audio-cinematics` decidindo o porquê de cada enquadramento.

## Follow de gameplay 3D (o padrão)

```
Camera3D + PhantomCameraHost (filho)
PhantomCamera3D "Gameplay": follow_mode=SIMPLE, follow_target=<jogador>,
  follow_offset=(0, 2.5, 6) no espaço da PCam, follow_damping=true,
  look_at_mode=SIMPLE, look_at_target=<jogador>, look_at_offset=(0, 1.2, 0)
```

Troca de área/estado = outra PCam com prioridade maior, não script empurrando esta.

## Terceira pessoa com colisão

```
PhantomCamera3D "ThirdPerson": follow_mode=THIRD_PERSON, follow_target=<jogador>,
  follow_distance≈4, spring_length≈4, collision_mask=<mundo>, margin≈0.2
```

O script do jogador gira **a PCam** (yaw/pitch com limites); o spring resolve parede/chão. Sensibilidade e inversão são configurações do jogador (`godot-ui-ux`), não constantes escondidas.

## Co-op/grupo sem split-screen

`follow_mode=GROUP` com todos os jogadores em `follow_targets` e `auto_follow_distance` ligado (min/max pela arena). Look-at `GROUP` mantém o centro da ação; teto de distância evita câmera no teto quando o grupo se espalha — arena se desenha para a câmera que existe.

## Cutscene por prioridade

1. PCams da cena com `follow_mode=NONE`, enquadradas à mão (ou `PATH` para travelling).
2. Entrar na cutscene: subir a `priority` da PCam da vez (tween dela manda: lento para estabelecer, seco para susto — gramática em `godot-audio-cinematics`).
3. Sair: restaurar a prioridade da gameplay e devolver controle no `tween_completed`/`became_active` — nunca no meio do voo sem querer.

Travelling contínuo entre pontos: PCams em sequência com prioridades crescentes, ou uma PCam `PATH` seguindo alvo que percorre o caminho.

## Shake que não briga

- Explosão/impacto: `PhantomCameraNoiseEmitter3D` no ponto do evento emitindo para a camada (`noise_emitter_layer`) que a PCam ativa escuta via seu recurso `PhantomCameraNoise3D` (amplitude/frequência no recurso, reutilizável entre PCams).
- Shake contínuo (veículo, terremoto): emissor persistente com intensidade por estado; pare o emissor, não a PCam.
- Nunca anime `Camera3D.position/rotation` por fora: o host sobrescreve e o resultado é briga visível.

## Câmera 2D (plataforma)

`PhantomCamera2D` + host na `Camera2D`: `FRAMED` com dead zone dimensionada pela velocidade, ou `SIMPLE` com damping assimétrico (X responde, Y espera). Limites de nível continuam sendo da `Camera2D`/PCam — defina antes de culpar o follow por mostrar fora do mundo.

---
_Receitas conferidas em 2026-10-17 contra a API da v0.11.0.3. Valores são ponto de partida: câmera se calibra jogando na velocidade real do personagem._
