---
name: godot-engine-resources
description: Recursos e ferramentas embutidas da engine Godot 4.7+ a partir da documentação oficial — Tween e tempos (Timer, create_timer, await), Resource sob medida (dados tipados, duplicate, local_to_scene, carregamento), Curve/Curve2D/3D e PathFollow, Gradient e FastNoiseLite, sinais/grupos e esperas. Use ao animar por código, temporizar lógica, modelar dados do jogo, amostrar curvas/ruído/gradientes ou seguir caminhos — antes de reinventar com código manual o que a engine já resolve.
---

# Godot Engine Resources

Metade do código "esperto" de projeto é a engine refeita à mão, pior. Esta skill é o inventário do que a Godot já entrega — **Tween, tempo, Resource, Curve, Gradient, Noise, PathFollow, sinais e esperas** — com a API conferida na [documentação oficial](https://docs.godotengine.org/en/stable/). Regra de uso: antes de escrever um sistema, passe por esta lista; se a engine faz, use a engine e gaste o código no que é do seu jogo.

As skills de domínio (3D, 2D, visual, UI, multiplayer) dizem **o quê** construir; esta diz com **qual peça da engine**. Sem API inventada: nome de método se confirma na classe oficial da versão.

## Pesquisa sempre (regra do pacote)

Antes de criar ou alterar qualquer coisa nesta disciplina, **pesquise informações e referências atuais**: documentação oficial da versão do projeto, referências de imagem/vídeo/texto e como quem é bom resolve o mesmo problema — e transforme a pesquisa em especificação antes de executar. Primeira ideia é rascunho, nunca entrega. Método completo (perguntas, fontes, verificação cruzada e registro): skill `agent-frontier-reasoning`. Sem internet, declare explicitamente o que ficou não verificado e baixe a confiança do afetado.

## Mapa rápido (a necessidade → a peça)

| Necessidade | Peça da engine |
|---|---|
| Animar propriedade com easing (mover, esmaecer, escalar) | `Tween` (`create_tween`, `tween_property/interval/callback/method`) |
| Esperar X segundos e agir / repetir a cada X | `Timer` (nó) ou `create_timer` (sem nó); `await` no sinal |
| Dados de jogo editáveis no inspetor e compartilhados | `Resource` sob medida (`class_name extends Resource`, `@export`) |
| Resposta por curva (dano×distância, aceleração, spawn) | `Curve` (`sample`) / `CurveTexture` onde é textura |
| Caminho com algo se movendo nele | `Curve2D/3D` + `Path2D/3D` + `PathFollow2D/3D` (`progress`) |
| Transição de cor/valor por faixa | `Gradient` (`sample`) / `GradientTexture1D/2D` |
| Aleatoriedade com forma (terreno, espalhar, variação) | `FastNoiseLite` + `NoiseTexture2D/3D`; `RandomNumberGenerator` com seed |
| Reagir a evento sem acoplar | sinais (`connect`, `await sinal`), grupos (`get_tree().call_group`) |
| Pausar/retomar com o jogo | `process_mode` da peça (Tween/Timer respeitam a árvore) |

## Padrões que valem para todas as peças

1. **Crie pela fábrica, não pelo construtor**: `Tween` nasce de `Node.create_tween()`/`get_tree().create_tween()` (`Tween.new()` é inválido, diz a documentação); timer sem nó nasce de `get_tree().create_timer()`. Peça criada do jeito errado "não funciona" sem erro claro.
2. **Dado é Resource, comportamento é nó**: número de balanceamento, tabela de itens e curva de dificuldade moram em `Resource` versionável e editável sem tocar em código.
3. **Tempo tem dono**: todo Tween/Timer declara (por construção ou configuração) se pausa com o jogo, se ignora `time_scale` e em que processo anda (idle × physics). Tempo sem dono é bug de pausa esperando acontecer.
4. **Compartilhado × único é decisão**: Resource é compartilhado por padrão — quem muda um, muda todos. `duplicate()`/`local_to_scene` entram onde a instância precisa ser dona da própria cópia, e essa decisão fica escrita onde o recurso é usado.

Detalhes por peça em [references/tween-e-tempo.md](references/tween-e-tempo.md), [references/recursos-e-dados.md](references/recursos-e-dados.md) e [references/curvas-ruido-e-caminhos.md](references/curvas-ruido-e-caminhos.md).

## Arquivos desta skill

| Arquivo | Conteúdo |
|---|---|
| [references/tween-e-tempo.md](references/tween-e-tempo.md) | Tween completo (tweeners, paralelo, loop, easing, morte/pausa), Timer × create_timer e await |
| [references/recursos-e-dados.md](references/recursos-e-dados.md) | Resource sob medida, export, duplicação, local_to_scene, carga (incl. threaded) e salvamento |
| [references/curvas-ruido-e-caminhos.md](references/curvas-ruido-e-caminhos.md) | Curve, Gradient, FastNoiseLite, Curve2D/3D + PathFollow e RNG com seed |
| [templates/peca-certa.md](templates/peca-certa.md) | Ficha curta: necessidade, peça escolhida, dono do tempo/dado e verificação |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de mudanças da skill |
