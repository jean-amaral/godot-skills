# Sprite e animação 2D

Animação 2D comunica estado e peso com poucos frames bem escolhidos. Muitos frames sem pose forte é o oposto de polimento.

## Qual ferramenta para qual animação

| Necessidade | Ferramenta |
|---|---|
| Trocar frames do sprite por estado (idle/run/jump) | `AnimatedSprite2D` + `SpriteFrames` (velocidade por animação, loop ou não) |
| Animar junto posição/escala/efeito, disparar som/partícula/método no marco (passo, golpe) | `AnimationPlayer` (tracks de propriedade e método) |
| Ataque com janela de hitbox precisa | Estado do personagem manda na hitbox; animação fornece o tempo (marco via track de método/sinal) |

As duas convivem: `AnimationPlayer` dirigindo o `AnimatedSprite2D` quando a cena pede sincronia fina.

## Ritmo e peso (por tipo de ação)

- **Idle**: respiração sutil, ciclo lento; personagem "morto" parado quebra imersão, exagero vira palhaço.
- **Corrida**: ciclo com contato/passagem nítidos, frequência casada com a velocidade real (pé escorregando = velocidade do ciclo ≠ velocidade do corpo).
- **Pulo/queda**: poses distintas para subindo, ápice e caindo (trocar por velocidade Y, não por timer); pouso tem frame de impacto curto.
- **Ataque**: antecipação curta → golpe rápido → recuperação legível. A janela de dano mora na antecipação/fim do golpe, definida pelo design — tempo de animação é dado de gameplay aqui, calibre junto com a `godot-2d-specialist`.
- **Dano/morte**: flash + recuo (knockback é movimento, não só cor); morte tem começo claro (o jogador precisa saber que morreu antes da tela de derrota).

## Squash & stretch (com teto)

- Deformação vende peso (esticar na queda, achatar no pouso) **no desenho**: a forma de colisão nunca acompanha. Teto pequeno (10–20%) acima disso a leitura do corpo quebra e o jogador erra pulo por causa do sprite.
- O mesmo vale para rotação de sprite em dash/giro: efeito visual não muda a caixa que o mundo respeita.

## Processo

1. Poses-chave (as 2–4 que contam a ação), aprovadas em silhueta.
2. Ligar nos estados (a ficha de movimento lista; animação que nenhum estado chama é enfeite esquecido).
3. Intermediários e ritmo jogando — ajuste FPS da animação contra velocidade real, nunca isolado no editor de sprite.
4. Marcos de som/passo/partícula por track/sinal, sincronizados com o frame (áudio: `godot-audio-cinematics`).

## Erros clássicos

- Um FPS global para tudo: corrida e idle no mesmo ritmo parecem boneco de teste.
- Animação decidindo gameplay ("o dano sai quando a animação chegar lá" sem dado): quem manda é o estado, a animação apresenta.
- Loop de corrida sem casar com a velocidade: o pé desliza e o cérebro registra "controle ruim" sem saber por quê.

---
_Orientação revisada em 2026-10-17 para Godot 4.7+. Ritmo se calibra jogando na velocidade real do personagem._
