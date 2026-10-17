# Tileset (arte) e parallax

O tileset é um sistema de peças, não uma ilustração cortada em quadrados. A parte mecânica (terrenos, física, dados) está em `godot-2d-specialist/references/tilemap-e-niveis.md`; aqui é a **arte** que faz esse sistema funcionar.

## Desenhar para o autotile

- Pense em **transições**, não em tiles soltos: miolo, borda (4 lados), canto externo, canto interno (quina) e variações de miolo. Faltando a quina interna, todo encontro de plataformas vira remendo manual.
- Um material por família (pedra, madeira, grama) com a mesma luz/paleta; variação sutil dentro da família (2–3 miolos alternados) evita o "papel de parede" sem quebrar a leitura.
- Topo jogável se distingue da lateral (a superfície onde se pisa lê diferente da parede): é assim que o jogador sabe onde pode pousar sem pensar.
- Perigo com linguagem própria e repetida (forma + cor + eventual animação): a primeira espinha ensina, as próximas são lidas de relance.

## Fundo e camadas (profundidade sem roubar a cena)

- Ordem de leitura por **contraste e saturação decrescentes** com a distância: plano de jogo mais presente; fundo, menos; primeiro plano (frente) só emoldura e nunca cobre gameplay sem transparência pensada.
- Parallax: cada camada com fator próprio (longe perto de 0, plano de jogo 1), testado andando nos dois sentidos — camada que "anda para trás" errado aparece na hora. Céu/gradiente é camada também, não cor de fundo esquecida.
- Repita com variação: textura de fundo em loop visível (costura óbvia, elemento repetido no mesmo ritmo) denuncia a grade; alterne espelhamento/variação onde o tile se repete demais.
- Silhueta de fundo conta onde estamos (arquitetura, vegetação do bioma) sem competir com a silhueta dos atores.

## Consistência com o resto

- Mesma grade e luz do tileset nos props 2D (porta, baú, placa): prop fora da grade/luz parece colado por cima.
- Mudança de bioma = nova família com transição desenhada (não corte seco de paleta no meio da fase, salvo decisão de direção registrada — gramática em `godot-audio-cinematics`/`godot-visual-craft`).

## Erros clássicos

- Tileset desenhado como pôster fatiado: bonito na folha, impossível de montar sala diferente.
- Fundo com mais contraste que o chão: o jogador lê o cenário e perde o personagem.
- Parallax simétrico que não sobrevive a andar para trás.

---
_Orientação revisada em 2026-10-17 para Godot 4.7+. Tileset se aprova montando três salas diferentes com ele, não olhando a folha de tiles._
