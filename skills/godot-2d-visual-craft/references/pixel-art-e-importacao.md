# Pixel art e importação

Pixel art borrada ou nadando destrói o estilo inteiro antes de qualquer arte ser julgada. Pipeline primeiro, desenho depois.

## Configuração do projeto (pixel art)

- **Filtro de textura desligado** para o projeto/sprites (vizinho mais próximo): pixel se amplia como bloco, não como mancha.
- **Importação sem perda** (lossless) e sem gerar artefato de compressão em sprite; mipmap conforme o uso (zoom-out forte sem mipmap cintila; com mipmap e filtro errado, borra — decida pelo zoom real do jogo).
- **Snap**: movimento e câmera arredondando para a grade de pixel do projeto (configurações de snap/renderização 2D da versão) — sem isso o sprite "nada" entre pixels ao andar devagar.
- **Escala inteira** quando o estilo pede (janela = resolução-base × 2, ×3): escala fracionária estica pixels desiguais. Resolução-base declarada (ex.: 480×270) e testada na janela real, não só no editor.

Arte pintada/HD 2D inverte o filtro (ligado) e dispensa snap de pixel: a ficha visual registra qual dos dois mundos o projeto é. Misturar os dois sem decisão é o erro.

## Produção da arte

- **Tamanho-base único**: tile e personagens em múltiplos da mesma grade (personagem 1×2 tiles). Sprite fora da grade quebra tileset, colisão e leitura juntos.
- **Paleta fechada** por ambiente (hex registrados na ficha), reutilizada entre props: paleta que cresce por sprite vira ruído visual.
- **Silhueta primeiro**: personagem/perigo se reconhecem em preto sólido no tamanho de jogo; detalhe interno é o que sobra depois.
- **Sprite sheet organizada**: grade regular, mesma âncora/pivô por frame (pé do personagem é âncora de plataforma), margem para não vazar frame vizinho. Pivô que anda entre frames = personagem patinando.
- Fundo e interativo em famílias visuais distintas (contraste/saturação): o que mata não pode ter a mesma presença do que decora.

## Erros clássicos

- Importar com filtro padrão e culpar a arte pelo borrão.
- Câmera suave sub-pixel sobre pixel art sem snap (o famoso "treme-nada").
- Personagem desenhado em 48 px sobre tile de 16 px sem razão de escala.
- Efeito/sombra em resolução diferente "para ficar suave" no meio do pixel art.

---
_Orientação revisada em 2026-10-17 para Godot 4.7+. Nomes de configurações de importação/renderização: confira na documentação da versão do projeto — elas mudam de lugar entre versões._
