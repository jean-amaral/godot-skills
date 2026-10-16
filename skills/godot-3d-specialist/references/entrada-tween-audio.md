# Entrada, tween e áudio 3D

## Entrada

- Ações nomeadas no Input Map (`move_forward`, `interact`), nunca tecla crua no código: rebind e controle dependem disso.
- Movimento lê o vetor de ação uma vez por frame de física com deadzone **radial** (vetor normalizado após a zona morta), não por eixo separado — diagonal e analógico parcial agradecem.
- Buffer de entrada para ação que precisa de timing (pulo/ataque): guarde o instante do aperto por ~0,1 s e consuma quando a condição abrir; sem buffer, o jogo "come" input e parece não responder.
- Coyote time curto no pulo é a mesma ideia do lado do chão. Os dois juntos, com valores no controlador, ajustáveis por playtest.
- Rebind em runtime: escute a próxima entrada, rejeite conflito com ação existente (ou confirme a troca) e **salve o mapa** nas configurações do jogador — rebind que some ao fechar não foi entregue.
- Câmera e personagem consomem a mesma leitura de entrada tratada; ninguém lê `Input` cru em dois lugares com deadzones diferentes.

## Tween

- Tween é dono do ciclo de vida dele: antes de criar outro na mesma propriedade, mate o anterior (`kill()`), ou dois tweens brigam pelo mesmo valor e o resultado é tremida.
- Sequência sincronizada com sinal prefere aguardar o passo (`await`) a temporizador paralelo; tween de apresentação pode ser interrompido sem quebrar estado — quem manda no estado é o sistema, o tween só desenha.
- UI e game feel usam curvas nomeadas no código de apresentação; nada de easing mágico espalhado.

## Áudio 3D

- Barramentos por papel no mixer (Master/Música/SFX/UI/Voz) com volume do jogador salvo por barramento; fonte nunca toca "no master" por preguiça.
- Som do mundo é `AudioStreamPlayer3D` com distância/unidade configuradas ao tamanho do nível; som de interface é 2D e não atenua.
- Pool de vozes para som repetitivo (tiro, passo, impacto): player único por fonte corta o som anterior — pool pequeno e round-robin resolve sem gerenciar voz na mão.
- Passo e impacto escutam o evento de gameplay/animação com variação de pitch sorteada em faixa curta; variação sem limite vira desenho animado.
- Música muda por estado do jogo (exploração/combate) com crossfade no barramento/players dedicados, não por stop seco na troca de cena.

---
_Referência revisada em 2026-10-16 (Godot 4.7.2). A suíte `tests/` prova os scripts do pacote; as receitas daqui são orientação de uso, não comportamento testado. Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._

> Direcao de audio completa (barramentos, musica adaptativa, mix) vive na skill companheira `godot-audio-cinematics`.
