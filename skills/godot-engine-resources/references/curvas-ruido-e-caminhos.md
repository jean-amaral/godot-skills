# Curvas, gradientes, ruído e caminhos (classes oficiais)

Peças de **forma**: transformar um número (distância, tempo, posição) em outro com comportamento desenhado, em vez de fórmula inventada por trecho de código.

## Curve — resposta desenhada

- `Curve.sample(x)` devolve o Y da curva em 0..1 (e `sample_baked` usa a versão assada, mais barata): dano que cai com a distância, aceleração que amacia no topo, chance de loot por nível. A curva é um `Resource` — balanceador ajusta no editor sem código.
- Onde a curva vira imagem (partícula, shader), `CurveTexture`/`CurveXYZTexture` fazem a ponte.
- Curva “no código” (`if` em cascata aproximando forma) é o anti-padrão: desenhe, versione, reutilize.

## Gradient — valor por faixa

- `Gradient.sample(x)` interpola cores/valores entre pontos: vida verde→vermelha **como dado** (a UI ainda precisa de redundância além da cor — `godot-ui-ux`), calor de mapa, tint por altura. `GradientTexture1D/2D` leva o gradiente a material/shader/partícula.
- Gradiente é Resource compartilhável: a paleta de uma mecânica (frio→quente) mora num lugar só.

## Curve2D/3D + PathFollow — caminho com tráfego

- `Path2D/Path3D` guarda a `Curve2D/3D` (pontos, baked com resolução); `PathFollow2D/3D` anda nela por `progress` (distância) ou `progress_ratio` (0..1), com `loop`, inclinação/alerão conforme a dimensão.
- Quem usa: inimigo em patrulha, câmera em trilho (em 3D, a alternativa dirigida é Phantom em modo PATH — `godot-phantom-camera`), projétil guiado, plataforma móvel sobre trilho, texto/props ao longo de caminho.
- Animar `progress` com **Tween** (`tween_property(follow, "progress", ...)`) é o caminho curto para movimento ao longo da curva com easing da engine — não calcule ponto-e-rotação na mão salvo necessidade específica (`curve.sample_baked`/`get_closest_point` existem para isso).
- Em rede, caminho é dado compartilhado: sincronize `progress`/estado, não cada posição amostrada (`godot-multiplayer`).

## FastNoiseLite e aleatoriedade com seed

- `FastNoiseLite` (com `NoiseTexture2D/3D` para virar textura) gera ruído configurável (tipo, frequência, oitavas/fBm, **seed**): variação de terreno, espalhar props, tremor orgânico, máscara de desgaste. Valor amostrado com `get_noise_2d/3d`.
- Aleatoriedade de gameplay usa `RandomNumberGenerator` **com seed registrada** quando o resultado precisa ser reproduzível (geração de fase, teste, replay) e `randf()/randi()` globais só para o descartável (variação visual sem consequência). Quem usa `randomize()` implícito perde a capacidade de reproduzir o bug que o jogador relatou.
- Ruído não é balanceamento: distribua **com regras** (o ruído propõe, o design filtra: altura mínima, distância de spawn, teto de densidade) — `godot-3d-specialist`/`godot-2d-specialist` consomem daí.

## Sinais, grupos e espera (cola da engine)

- Sinal próprio (`signal`, `emit`, `connect`, `await sinal`) desacopla quem avisa de quem reage; grupo (`add_to_group`, `get_tree().call_group`) chama coleções sem referência direta (pausar inimigos, reiniciar coletáveis).
- `call_deferred` agenda para o fim do frame (mexer na árvore durante física/callback é o caso clássico); ` Callable` é o valor que passa "o que chamar depois" entre sistemas (o Tween e o RPC vivem disso).

---
_Referência criada em 2026-10-17 a partir das classes oficiais (`Curve`, `Gradient`, `FastNoiseLite`, `PathFollow2D/3D`, `RandomNumberGenerator`) na documentação estável da Godot 4.7._
