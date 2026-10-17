---
name: godot-multiplayer-3d
description: Multiplayer 3D na Godot 4.7+ sobre o núcleo godot-multiplayer — sincronizar CharacterBody3D e física 3D, interpolação de avatares remotos, autoridade de tiros/dano, áreas de interesse e câmeras por jogador (incl. Phantom Camera em rede). Use quando o jogo 3D (co-op ou competitivo) precisar de jogadores/inimigos/mundo sincronizados em rede.
---

# Godot Multiplayer 3D

O contrato de rede (autoridade, RPC, spawn, segurança, sessão) é da skill-mãe `godot-multiplayer` — **leia-a primeiro**. Esta skill é o que muda quando o mundo tem três dimensões, física Jolt e câmera por jogador.

Base 3D: `godot-3d-specialist`. Câmera: `godot-phantom-camera` (uma câmera real por processo — em rede, cada máquina só tem a sua).

## O que sincroniza em 3D (e como)

| Coisa | Desenho |
|---|---|
| Avatar do jogador | Spawn pelo servidor; autoridade = dono. Posição/rotação sincronizadas (Synchronizer, intervalo curto), interpoladas nos remotos |
| Input do dono | Local; competitivo: intenção via RPC para a autoridade validar e mover |
| Inimigo/NPC | Autoridade = servidor; clientes apresentam (animação por velocidade/estado, não por física local) |
| Física solta (caixa, bola, destroço) | **Um dono só simula** (servidor); remotos apresentam interpolado. Duas físicas simulando o mesmo corpo divergem em segundos |
| Tiro/dano | Hitscan: servidor valida origem/direção/alcance e aplica dano. Projétil: servidor spawna e sincroniza; cliente pode previsualizar sem decidir acerto |
| Porta/veículo/estado do mundo | Autoridade do servidor, estado On Change + eventos confiáveis |

## Movimento e interpolação

- O avatar remoto tem **duas verdades separadas**: posição de rede (a que chega) e posição apresentada (a que a câmera vê). A apresentada persegue a de rede com suavização em `_physics_process`, com corpo remoto normalmente **sem colisão decisiva** (colisão dele é problema da autoridade) — remoto que empurra o mundo local com posição velha fabrica briga de física.
- Rotação do corpo e da mira são propriedades separadas: corpo interpola (slerp), mira (pitch/yaw de câmera/arma) sincroniza com intervalo próprio onde a precisão pede.
- Física roda em ticks: sincronize em intervalo compatível com o tick (não prometa precisão maior que a cadência de envio), e marque divergência aceitável por gênero (co-op perdoa, shooter cobra reconciliação — a Godot não reconcilia por você: cliente que prevê precisa corrigir quando o servidor discorda, suavemente).
- Animação remota por **dado sincronizado** (estado de locomoção, velocidade, no chão?) alimentando a `AnimationTree` local — sincronizar pose de esqueleto é banda jogada fora.

## Áreas de interesse e escala

- Mundo grande = visibilidade por interesse: Synchronizer com filtros de visibilidade por área/célula (servidor atualiza quem vê quem ao trocar de área). Todos veem todos só funciona em arena pequena.
- Câmera e áudio são **locais**: cada processo tem sua Camera3D (Phantom: cada um com seu Host/PCams apontando para o **seu** avatar) e seus ouvintes. PCam de outro jogador não é replicada como câmera de ninguém — o que replica é o avatar que ela segue na máquina dela. Nada de replicar nó de câmera esperando que "a câmera dele apareça aqui".
- Inimigo distante dorme na autoridade também: sincronizar inimigo fora de qualquer interesse é banda e CPU queimadas; ative por proximidade de algum jogador.

## Testes específicos 3D

- [ ] Dois avatares se atravessando/empurrando: sem briga de física nos remotos.
- [ ] Tiro dos dois lados (inclusive com latência simulada): acerto igual nas duas telas, decidido pela autoridade.
- [ ] Corpo físico solto (empurrar caixa) nas duas telas sem divergência visível crescente.
- [ ] Câmera de cada um só segue o seu (Phantom Host local), inclusive após respawn.
- [ ] Inimigo sincronizado entra/sai de área de interesse sem pop seco (spawn/despawn suave).

## Arquivos desta skill

| Arquivo | Conteúdo |
|---|---|
| [references/sincronizacao-3d.md](references/sincronizacao-3d.md) | Avatar remoto interpolado, física com dono, tiro/dano e animação por dado |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de mudanças da skill |
