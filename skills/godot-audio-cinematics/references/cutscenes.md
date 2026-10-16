# Cutscenes que respeitam o jogador

## Estrutura

- A sequência mora num `AnimationPlayer` dedicado da cena (não no do
  personagem): tracks de câmera, atores, método (batidas) e áudio.
- Batida importante (fala, revelação, porta que abre) emite sinal pelo
  tocador ([../scripts/cutscene_player.gd](../scripts/cutscene_player.gd),
  método `mark_step("nome")` numa track de método): sistemas escutam a
  batida, a cutscene não conhece sistema nenhum.
- Shot list antes do editor ([../templates/shot-list.md](../templates/shot-list.md)):
  cada plano com duração, câmera, som e **como sai dele**.

## Entrar e sair sem quebrar o jogo

1. **Entrar**: salvar estado de controle (quem se move, qual câmera está
   ativa), desligar entrada do jogador, ativar câmera da cena e letterbox.
2. **Durante**: jogador não pausa a física do mundo sem querer — defina o
   que continua vivo (ambiente sim, inimigo atacando o herói parado, não).
3. **Sair**: pelo fim **ou pelo pulo**, o caminho é o mesmo: aplicar o
   estado final combinado (posições, flags, câmera devolvida, controle
   religado) e emitir `finished`. Pulo que só para a animação deixa o
   jogo no meio da cena — o bug clássico de cutscene.

## Pulo (skip) bem feito

- Primeiro toque em pular: mostra o aviso ("segure para pular" ou ícone);
  pular acidentalmente a história é tão ruim quanto não poder pular.
- Pular = avançar ao estado final e emitir o mesmo `finished` do caminho
  normal. Quem escuta o fim não sabe (nem precisa saber) se houve pulo.
- Cena já vista pode nascer pulável de imediato; cena nova merece o aviso.

## Ritmo

- Plano que não muda informação, emoção ou posição já acabou — corte.
- Diálogo com tempo de leitura: a batida dura o texto, não o dobro dele.
- A última batida devolve a câmera **em direção ao próximo objetivo**:
  o jogador sai da cena olhando para onde o jogo continua.

---
_Referência revisada em 2026-10-16 (Godot 4.7.2). A suíte `tests/` prova os scripts do pacote; as receitas daqui são orientação de uso, não comportamento testado. Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
