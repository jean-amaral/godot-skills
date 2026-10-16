# Shaders realistas: receitas-base

Shaders em [../shaders/](../shaders/), sintaxe conferida na Godot 4.7.2
pela suíte da skill. Cada receita nasce de uma referência: ajuste os
parâmetros contra a sua, não contra o seu gosto isolado.

## realistic_water.gdshader — água de rio/lago

- Dois scrolls de normal em direções/escalas diferentes = fluxo sem repetição óbvia.
- Fresnel mistura cor rasa × profunda; `depth_fade` suaviza a borda na
  margem (precisa de renderização com profundidade — custo declarado).
- Espuma por faixa de profundidade rasa + ruído: regule `foam_distance`
  contra a referência, não no máximo.
- Reflexo verdadeiro é da sonda/GI do ambiente; o shader não finge céu.

## realistic_glass.gdshader — vidro de janela/garrafa

- Fresnel forte na borda, centro quase transparente tingido (`tint`).
- Sem refração de verdade por padrão (custo): se a cena pedir, ative a
  leitura de tela do material com orçamento aprovado — vidro herói só.
- Sujeira/condensação entram como máscara no roughness, não como segunda malha.

## terrain_blend.gdshader — terreno de dois materiais

- Mistura por **inclinação** (plano = grama/terra, íngreme = rocha) com
  faixa de transição por ruído, mais variação de macro para matar repetição.
- Albedo/roughness por camada; normal combinada com o relevo da malha.
- Escala de mundo (não UV de objeto) para a textura não esticar por peça.

## foliage_wind.gdshader — folhagem e grama

- Vento por vértice ponderado pela altura local da folha (base presa,
  ponta livre), com fase por instância para a moita não balançar em bloco.
- Duas frequências (rajada lenta + tremida rápida) lidas de referência de
  vento real; amplitude em metros, não em "unidades de efeito".

## Regras comuns

- `uniform` com faixa e padrão seguro; nome do fenômeno, não da variável (`deep_color`, não `color2`).
- Transparência e tela cheia são orçamento: um herói por cena até medir.
- Shader que depende de textura externa recebe a textura do material do projeto (baixada com licença, via `godot-free-assets`), nunca embute caminho de máquina.
- Aprovado é na cena, com a luz final e a câmera do jogo — preview isolado mente.

---
_Referência revisada em 2026-10-16 (Godot 4.7.2). A suíte `tests/` prova os scripts do pacote; as receitas daqui são orientação de uso, não comportamento testado. Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
