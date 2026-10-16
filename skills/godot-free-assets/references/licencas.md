# Licenças: o que entra, o que não entra e como creditar

Critério deste pacote (decisão do criador): **somente CC0 e CC-BY**, pois o
projeto pode virar comercial. "Grátis para baixar" não é licença.

## Tabela de decisão

| Licença | Entra? | Crédito | Observação |
|---|---|---|---|
| CC0 1.0 / domínio público | ✅ | Não exigido (registramos por cortesia) | Uso comercial, modificação e redistribuição livres |
| CC-BY 3.0/4.0 | ✅ | **Obrigatório** (autor, título, fonte, licença, alterações) | Gere o crédito no ato do download |
| CC-BY-SA | ❌ padrão | — | Share-alike contamina derivados; só com decisão explícita e registrada do criador |
| CC-BY-NC (qualquer NC) | ❌ | — | Não-comercial: mata monetização, anúncio e venda futura |
| CC-BY-ND (qualquer ND) | ❌ | — | Sem derivados: asset de jogo é quase sempre modificado |
| OGA-BY, GPL e afins | ❌ padrão | — | Fora do critério; exceção só registrada |
| "Free", licença própria de loja, sem licença | ❌ | — | Sem texto de licença aberto, não há permissão provada |

## Evidência aceitável (nesta ordem)

1. `License.txt`/`LICENSE` **dentro** do pacote baixado.
2. Página oficial de licença da fonte (vale para fontes CC0 integrais).
3. Campo de licença na página do asset ou no JSON da API.

Duas evidências concordando bastam; divergindo, **não baixa**. Guarde a URL
da evidência no manifesto — é ela que defende o projeto depois.

## Formato do crédito (gerado em CREDITS.md)

```text
- "Título do Asset" por Autor — https://fonte.example/asset
  Licença: CC BY 4.0 — https://creativecommons.org/licenses/by/4.0/
  Alterações: redimensionado para 1K / convertido para .glb (ou "sem alterações")
```

- Crédito CC-BY vai no `CREDITS.md` do projeto **e** na tela de créditos do
  jogo quando ele for distribuído. Um sem o outro é meia obrigação.
- Asset modificado continua CC-BY: marque a alteração; não remova o autor.
- Junte vários assets do mesmo autor/fonte em entradas separadas por item:
  crédito genérico "assets de fulano" não identifica a obra.

## Termos da fonte ≠ licença do asset

API e site podem impor termos próprios (User-Agent identificável, ritmo de
requisições, proibição de espelhar o catálogo) mesmo com asset CC0. Respeitar
os dois: a licença libera o **asset**; os termos regulam o **acesso**.
Contornar login, paywall, captcha ou limite técnico encerra a busca naquela
fonte — procure outra.
