# Arquitetura e fundação do projeto

## Camadas (quem pode chamar quem)

```text
Apresentação (UI, câmera, efeitos)  →  Gameplay (sistemas, componentes)
Gameplay                            →  Dados (Resource, configs)
Infraestrutura (save, áudio, loader) →  Dados
Dados                               →  nada (folha)
```

Apresentação nunca altera dado direto: emite sinal ou chama a API pública do sistema. Sistema nunca conhece a UI pelo nome.

## Escolha do tipo-base

| Precisa de | Use |
|---|---|
| Existir na árvore, transformar 3D, física | `Node` / `Node3D` |
| Ser dado salvável/inspecionável, sem transform | `Resource` customizado |
| Valor leve criado e descartado toda hora | `RefCounted` |
| Lógica pura sem estado de cena | classe com funções `static` ou `RefCounted` |

## Composição antes de herança

- Entidade = nó raiz fino + componentes filhos (`HealthComponent`, `InteractionComponent`), cada um com uma responsabilidade e sinais próprios.
- Dependência entra por `@export` (injetada no editor) ou por parâmetro — nunca por caminho absoluto `$"/root/..."` espalhado.
- Autoload só para serviço de vida longa (save, áudio, loader, estado global). Se tudo vira autoload, o projeto ganhou um "God object" com outro nome: sintoma é autoload importando cena de gameplay.

## Boot previsível

1. Ordem de autoloads declarada e curta: config → save → áudio → loader.
2. Sistema que depende de outro se declara pronto por sinal (`ready` próprio), não por `await get_tree().process_frame` chutado.
3. Em CI, o projeto precisa importar e abrir a cena inicial headless sem erro — isso pega boot quebrado antes do build.

## Sinais saudáveis

- Sinal tipado com nome no passado pelo emissor (`health_changed(current, maximum)`), quem escuta decide.
- Conecte em `_ready()` com a referência do sinal (`button.pressed.connect(_on_pressed)`), nunca por string.
- Lambda conectada em objeto que pode morrer: desconecte em `_exit_tree()` ou use `CONNECT_ONE_SHOT` quando for disparo único; conexão órfã é o vazamento clássico de sinal.
- Regra de direção: sinal sobe (filho→quem escuta), chamada desce (pai→filho). Filho não chama método do pai.

## Resource sem armadilha

- `Resource` compartilhado é **compartilhado de verdade**: alterar HP num `EnemyData.tres` altera todos. Estado por instância pede `resource_local_to_scene = true` ou `duplicate()` na criação da entidade.
- Duplicar para isolar é `duplicate(true)` (profundo) quando há sub-recursos; raso quando só o contêiner muda.
- Dado que o jogador edita (save) não mora em `.tres` em `user://` — ver [save-load-3d.md](save-load-3d.md).

## Carregamento e troca de cena

- Cena pesada carrega com `ResourceLoader.load_threaded_request()` + `load_threaded_get_status()` na tela de loading; `load()` síncrono na troca trava o frame.
- Troca de cena mantém serviços (autoloads) e descarta o mundo: instancie a nova, adicione, libere a anterior. Respawn do jogador não precisa recarregar o nível inteiro.
- Confira erro de cada etapa (`request`, `status == THREAD_LOAD_LOADED`) e tenha tela de erro: caminho errado em build exportado não abre o editor para avisar.

## Pausa e tempo

- Pause por `get_tree().paused = true` + `process_mode` nos nós que continuam vivos (menu = `PROCESS_MODE_ALWAYS`; mundo = pausável). Nó que ignora pause sem querer é bug de menu clássico.
- Lógica de gameplay em `_physics_process` quando depende de física; `_process` é apresentação.

---
_Referência revisada em 2026-10-16 (Godot 4.7.2). A suíte `tests/` prova os scripts do pacote; as receitas daqui são orientação de uso, não comportamento testado. Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
