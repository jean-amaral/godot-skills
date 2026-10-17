# Glossário e chaves — <jogo>

## Idiomas do projeto

- Obrigatórios: `pt-BR` (português brasileiro) · `en` (inglês) — paridade de chaves sempre.
- Futuros: <...> · Fallback do projeto: <en>

## Convenção de chaves

- Formato: `AREA_ACAO_DESCRICAO` — ex.: `MENU_START`, `HUD_HEALTH_LOW`, `DIALOG_<PERSONAGEM>_<NN>`.
- Chave nunca muda de significado; chave nova para texto novo. Renomear = migração registrada aqui.

## Glossário (mesmo conceito, mesmo termo)

| Conceito | pt-BR | en | Nota |
|---|---|---|---|
| <ex.: moeda do jogo> | | | |

## Estilo por idioma

- pt-BR: <caixa de título, tratamento (você), pontuação>
- en: <title case?, termos da engine mantidos>

## Verificação por entrega

- [ ] Paridade de chaves pt-BR × en (sem faltante, sem órfã)
- [ ] Troca em runtime com o jogo aberto (tudo muda junto)
- [ ] Plurais 0/1/2/muitos e frases com valores nos dois idiomas
- [ ] Pseudolocalização rodada sem quebra de layout nem tofu
