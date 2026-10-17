# Modelo e operações (o sistema sob a tela)

## Definição × instância (a separação que sustenta tudo)

- **Definição** (`Resource`, um por tipo de item): `id` estável, nome/descrição por chave (`godot-localization`), ícone, família, regras (empilhável/teto, slot de equipamento, consumível, valor, peso/tamanho de grade). Balanceamento mora aqui e muda sem código.
- **Entrada** (o que o inventário guarda): `{id, quantidade}` para fungíveis; **instância** própria quando há estado (durabilidade, qualidade, encantamento) — instância referencia a definição por id, nunca duplica a definição.
- Item único (a espada nomeada) é instância com quantidade travada em 1 por desenho, não por exceção no código da UI.

## Operações (funções do sistema, resultado explícito)

| Operação | Contrato |
|---|---|
| `adicionar(id, qtd)` | Preenche pilhas existentes antes de abrir novas; devolve **o que não coube** (0 = tudo entrou) |
| `remover(id, qtd)` | Recusa (sem efeito parcial) quando não há o suficiente, salvo contrato contrário registrado |
| `mover(origem, destino)` / `trocar(a, b)` | Válida ou não acontece; grade espacial valida encaixe **antes** de mexer |
| `dividir_pilha` / `juntar` | Metade/resto previsíveis; juntar respeita o teto e devolve o excedente ao lugar |
| `equipar(slot, entrada)` / `desequipar` | Equipado sai do pool comum conforme a regra (ocupa slot do inventário ou não — decisão da entrevista, aplicada sempre igual) |
| `usar(entrada)` | Consumível aplica o efeito pelo sistema do efeito, não pela tela; inventário só debita **após** o uso ser aceito |

- Toda operação emite sinal de mudança (o que mudou) — HUD, hotbar, som de UI e save escutam; **ninguém faz polling** do inventário por frame.
- Operação composta (comprar = pagar + adicionar) é atômica: falhou um passo, nada aconteceu — e o motivo volta para a apresentação mostrar.

## Limite e cheio

- O limite (slots/peso/grade/ilimitado) é verificado **na operação**, nunca na tela: a UI pode até impedir o clique, mas quem garante é o sistema (rede e script também chamam operações).
- Cheio tem comportamento único e nomeado vindo da entrevista. O sistema sinaliza `cheio`/recusa com o item envolvido; largar no chão é spawn pela regra do mundo, não efeito colateral escondido do `adicionar`.

## Loot, economia e save

- Loot é tabela de dados (peso por id) sorteada com RNG de seed registrada (`godot-engine-resources`); quem recebe o resultado é o `adicionar`, com o não-coube tratado na hora (fica no chão/corpo).
- Vender/comprar passa pela economia em inteiros do pacote; preço é da definição (com modificadores listados), nunca digitado na tela da loja.
- **Save**: lista de entradas `{id, quantidade, estado?}` + vínculos da hotbar (índice → entrada/id); carregar valida id contra o catálogo atual (item que não existe mais é relatado e removido com aviso, não quebra o save). Itens de quest e flags seguem o padrão de quests do pacote.

## Multiplayer (quando houver)

- Inventário com valor (competitivo, economia, loot disputado) é **da autoridade**: cliente pede (RPC), servidor opera e o resultado sincroniza (`godot-multiplayer`). Inventário local/co-op confiável pode ser do dono — decisão registrada na especificação, com o mesmo modelo de operações dos dois lados.
- Arrastar item na tela do cliente nunca é a verdade: a verdade é a operação aceita. Apresentação otimista que discorda do servidor se corrige sem duplicar nem sumir com item.

---
_Referência criada em 2026-10-17, alinhada ao padrão data-driven e de save do pacote. Operação que a UI implementa por conta própria é dívida: desça para o sistema._
