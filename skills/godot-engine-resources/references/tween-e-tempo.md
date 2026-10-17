# Tween e tempo (documentação oficial da Godot 4.7)

Fontes: classes `Tween`, `Timer`, `SceneTreeTimer` e `SceneTree.create_tween/create_timer` em [docs.godotengine.org](https://docs.godotengine.org/en/stable/).

## Tween — animação por código com dono

Criação válida (só estas duas; `Tween.new()` produz Tween inválido):

```gdscript
var tween := create_tween()            # Node.create_tween(): morre/pausa com o nó
var tween := get_tree().create_tween() # SceneTree: vive com a árvore
```

A sequência se monta com **Tweeners**, executados em ordem:

| Tweener | Para quê |
|---|---|
| `tween_property(obj, "prop", final, duração)` | Interpolar propriedade (posição, modulate, escala, valores de shader via método/propriedade) |
| `tween_interval(tempo)` | Esperar dentro da sequência |
| `tween_callback(Callable)` | Chamar função naquele ponto (soltar item, tocar som, liberar) |
| `tween_method(Callable, de, até, duração)` | Interpolar chamando seu método (quando não é propriedade direta) |
| `tween_subtween(tween)` / `tween_await(sinal)` | Aninhar outro Tween / esperar um sinal no meio da sequência |

- **Paralelo**: `tween.parallel()` faz o próximo Tweener rodar junto com o anterior; `set_parallel(true)` põe todos juntos. Sequência × paralelo é a diferença entre "anda e some" e "anda enquanto some".
- **Easing por trecho**: `set_trans(Tween.TRANS_*)`, `set_ease(Tween.EASE_*)` no Tweener (ou no Tween, valendo para os próximos). A curva errada é o que separa "UI viva" de "UI derretendo".
- **Loop e velocidade**: `set_loops()` (0 = infinito), `set_speed_scale()`. Loop infinito sem condição de parada é vazamento com boa aparência.
- **Vida útil**: `kill()` encerra (e é o que fazer ao trocar de estado/tela); Tween de nó criado com `create_tween()` é amarrado ao nó (`bind_node` é o explícito para o da árvore); Tween solto que sobrevive à cena anima objeto morto — erro clássico de "propriedade em instância liberada".
- **Pausa/processo**: `set_pause_mode(TWEEN_PAUSE_*)` (pausa com a árvore, continua no pause, etc.) e `set_process_mode(TWEEN_PROCESS_IDLE/PHYSICS)`. Menu que pausa o jogo mas cuja animação congela junto = pause_mode errado.
- **Sinais**: `finished`, `step_finished`, `loop_finished` — `await tween.finished` compõe sequência maior sem callback aninhado.
- Tween × AnimationPlayer: valores finais desconhecidos/dinâmicos e lógica em código → Tween; coreografia visual ajustada no editor → AnimationPlayer. Reimplementar um com o outro é o desperdício que esta skill existe para evitar. Na linha 4.6/4.7, `AwaitTweener` entra nas animações — confira a versão (matriz do pacote em `godot-3d-specialist`).

## Tempo sem Tween: Timer, create_timer e await

| Peça | Quando |
|---|---|
| `Timer` (nó) | Temporização visível/editável na cena, repetitiva ou com pause próprio: `wait_time`, `one_shot`, `autostart`, sinal `timeout`, `start/stop`, `time_left` |
| `get_tree().create_timer(s)` (`SceneTreeTimer`) | Esperar uma vez sem criar nó: `await get_tree().create_timer(0.5).timeout` |
| `await` em sinal qualquer | Esperar **o evento**, não o relógio: próximo frame (`get_tree().process_frame`/`physics_frame`), animação acabar, corpo entrar na área |

- Timer respeita `Engine.time_scale` salvo `ignore_time_scale=true` (relógio de UI real em jogo com slow-motion é o caso clássico), e `process_callback` escolhe física × idle — cooldown de gameplay em física, cronômetro de UI em idle.
- **`await` não é thread**: a função pausa naquela linha e volta quando o sinal emite; se o objeto for liberado no meio, ela não volta — guarde a continuação do que pode morrer (abaixo) e trate "quem me esperava morreu" como caso normal.
- Esperar com `_process` acumulando delta na mão é o anti-padrão que Timer/create_timer aposentam: some com pausa/time_scale errados e ninguém audita.

## Erros clássicos

- `Tween.new()` e a conclusão de que "Tween não funciona".
- Tween novo a cada frame para o mesmo alvo (empilha interpolações brigando); guarde a referência, `kill()` o antigo ao redirecionar.
- Cooldown com Timer de `autostart` esquecido ligado, disparando antes da cena existir para o jogador.
- `await` em sinal de objeto que pode ser liberado, virando função zumbi que nunca retorna e ninguém nota.

---
_Referência criada em 2026-10-17 a partir das classes oficiais na documentação estável (Godot 4.7). Confira assinatura na versão do projeto antes de usar tweener/modo novo._
