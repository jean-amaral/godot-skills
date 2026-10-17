# Escrita localizável (documentação oficial de i18n)

Fonte: [Internationalizing games](https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html) (Godot 4.7).

## Chaves, não frases

- Convenção do pacote: `AREA_ACAO_DESCRICAO` em maiúsculas (`MENU_START`, `HUD_OBJECTIVE_DONE`, `DIALOG_MARIA_03`). Chave estável é contrato: renomear chave quebra as traduções que apontam para ela — chave muda com migração registrada, não por gosto.
- `tr("CHAVE")` resolve no idioma atual; texto dinâmico também passa por ele (`tr("GAME_STATUS_%d" % indice)` quando o padrão é fechado) — mas prefira placeholders nomeados quando há mais de um valor.

## Frases com valores (ordem é gramática)

```gdscript
# Errado: quebra qualquer idioma com ordem diferente
label.text = "Você pegou a " + arma_nome
# Certo: cada idioma ordena os nomes como precisa
label.text = tr("{character} pegou a {weapon}").format({"character": nome, "weapon": arma})
```

- `%` posicional (`"%s pegou %s"`) serve com um/dois valores de ordem óbvia; com contexto para o tradutor, **nomeado vence**: quem traduz vê `{weapon}` e sabe o que é; com `%s` ele adivinha.
- Nome próprio, item e título que entram na frase **também são chaves traduzidas** quando o jogador os lê — traduzir a frase e deixar o item cru no meio é meia localização.

## Contexto (a mesma palavra, dois textos)

`tr("Close", "Actions")` ("Fechar") × `tr("Close", "Distance")` ("Perto"): contexto desambigua para o tradutor e permite traduções diferentes da mesma fonte. Sem contexto, um dos dois nasce errado em algum idioma.

## Plural (regra da engine, não do programador)

- Use a pluralização oficial nas traduções (formas por idioma no arquivo): português e inglês têm singular/plural, outros idiomas têm mais formas e cortes diferentes — `if n == 1` escrito no código **mente** para eles.
- Plural vale para contagem inteira ≥ 0. Quantidade contínua ("1,5 kg"), negativa ou medida não é plural de contagem: formate o número por idioma e use o substantivo na forma do idioma, sem fingir regra de plural.
- Teste sempre 0, 1, 2 e um número grande, nos dois idiomas — 0 é onde metade dos plurais quebra.

## Formatação por idioma

- Número decimal, milhar, data/hora e moeda seguem o idioma ativo (formatadores da engine/sistema), nunca string montada com ponto fixo: "1.5" em inglês é "1,5" em pt-BR, e o jogador nota.
- Maiúsculas são estilo por idioma: título todo em caixa-alta em inglês não se copia mecanicamente para o português. Glossário e guia de estilo por idioma moram em [templates/glossario-e-chaves.md](../templates/glossario-e-chaves.md).

## Erros clássicos

- Frase montada por concatenação com adjetivo antes/depois do substantivo ("espada grande" nasce "grande espada" noutro idioma — ou pior).
- Sigla/atalho de teclado desenhado dentro da frase traduzida (a tecla muda com layout/idioma e remapeamento — `godot-ui-ux` cuida do glifo dinâmico).
- Texto em textura/sprite sem remap nem Label (a "placa" em inglês no jogo em português).

---
_Referência criada em 2026-10-17 a partir da documentação oficial de internacionalização da Godot 4.7._
