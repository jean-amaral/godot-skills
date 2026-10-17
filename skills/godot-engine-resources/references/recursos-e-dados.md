# Resource e dados (documentação oficial: classe `Resource`)

`Resource` é o dado de primeira classe da Godot: editável no inspetor, salvável em `.tres`, compartilhável entre cenas. Sistema sem Resource tende a virar constante espalhada em script.

## Resource sob medida

```gdscript
class_name ItemData
extends Resource

@export var nome: String = ""
@export var preco: int = 0
@export var icone: Texture2D
```

- `@export` com tipo é o contrato: inspetor certo, erro cedo. Dado de balanceamento (dano, vida, preço, curva) mora aqui e muda sem recompilar nada.
- Resource pode ter métodos e sinais próprios (`emit_changed()` avisa quem usa que o dado mudou — a UI que lê vida/configuração se atualiza por aí, não por polling).
- Arrays/dicionários **tipados** no export mantêm o inspetor e o acesso honestos.

## Compartilhado × cópia (a decisão central)

| Situação | Peça |
|---|---|
| Definição igual para todos (item do catálogo, config do inimigo-base) | Resource compartilhado (um `.tres`, muitas referências) |
| Estado por instância (vida atual sobre a definição, material com cor própria) | `duplicate()` ao instanciar, ou `resource_local_to_scene = true` no recurso da cena |
| Mudança em runtime que não pode vazar para o arquivo/outras instâncias | Duplique **antes** de mudar; mudar Resource compartilhado muda o jogo inteiro (e parece "bug fantasma" em outra cena) |

- Material/visual por instância segue a mesma regra (o pacote já a aplica em materiais 3D: variação é por instância duplicada ou uniforme, nunca editando o compartilhado sem querer).
- `duplicate_deep()` quando a cópia precisa levar os sub-recursos junto; `duplicate()` raso compartilha os filhos — escolha consciente, não padrão.

## Carga e salvamento

- `load(path)` (cacheado pela engine: mesmo path, mesmo Resource) para o síncrono pequeno; `ResourceLoader.load_threaded_request/get` para cena/recurso pesado sem travar a tela (o loader de cenas do pacote usa isto).
- Salvar dado de **definição** é trabalho do editor (`ResourceSaver.save` em ferramenta) ou do build; **save de jogo** (progresso do jogador) não é `.tres` vindo de `user://` — é JSON/binário validado (regra do pacote: save nunca executa código do jogador). Não misture os dois mundos.
- Path de recurso é contrato: mover/renomear `.tres` quebra referência silenciosamente em cena — renomeie pelo editor/filesystem dock, que atualiza dependências.

## Erros clássicos

- Editar um Resource no inspetor de **uma instância** achando que é só dela (era o compartilhado).
- Constantes de balanceamento em cinco scripts que divergem na segunda semana.
- Salvar estado mutável no Resource de definição e "o inimigo nascer com vida pela metade" para sempre.
- Reimplementar tabela de itens com dicionários em código quando um `Resource` por item daria inspetor, ícone e validação de graça.

---
_Referência criada em 2026-10-17 a partir da classe `Resource` oficial (Godot 4.7). Sem API inventada: método de carga/salvamento se confirma na versão do projeto._
