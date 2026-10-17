---
name: godot-localization
description: Localização de jogos Godot 4.7+ (i18n) a partir da documentação oficial — todo jogo do pacote nasce em no mínimo português brasileiro (pt-BR) e inglês (en): texto por chave com tr(), traduções importadas (CSV/PO) registradas no projeto, TranslationServer e troca de idioma em runtime, plurais e contexto, pseudolocalização, fontes e recursos por idioma. Use ao escrever qualquer texto visível ao jogador, adicionar idioma, traduzir interface/diálogo ou preparar o jogo para publicar em mais de um idioma.
---

# Godot Localization

**Regra do pacote: todo jogo nasce em pelo menos dois idiomas — português brasileiro (`pt-BR`) e inglês (`en`).** Não é fase final: é fundação. Texto escrito como string solta hoje é retrabalho em todas as telas amanhã; texto por chave desde o primeiro menu custa quase nada.

Base oficial: [Internationalizing games](https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html) e a importação de traduções da documentação da Godot 4.7. Experiência da interface localizada (espaço, foco, leitura): `godot-ui-ux`. Assets por idioma (placa, voz): remaps, abaixo.

## O contrato (desde o primeiro texto)

1. **Nenhum texto visível ao jogador é string solta** em nó ou script: é **chave** (`MENU_START`, `HUD_HEALTH`, `ITEM_SWORD_NAME`) resolvida com `tr()`. Termos da engine ficam em inglês no código/identificadores; o jogador lê a chave traduzida.
2. **Os dois idiomas andam juntos**: chave nova nasce com `pt-BR` **e** `en` na mesma alteração. Chave sem tradução num dos dois é defeito visível (o fallback não é desculpa para entregar cru).
3. **Idioma é configuração do jogador**, salva e aplicada em runtime (`TranslationServer.set_locale`), com padrão inteligente na primeira vez: idioma do sistema operacional quando houver tradução, caindo para o fallback do projeto.

## Fluxo de trabalho

### 1. Escrever localizável

- No código: `label.text = tr("LEVEL_5_NAME")`; com valores, **nunca** monte frase por concatenação — use placeholders nomeados: `tr("{character} pegou a {weapon}").format({...})`, que cada idioma ordena como sua gramática manda. Concatenar `"Você pegou " + item` quebra qualquer idioma que não seja o seu.
- No editor: propriedades de texto de `Control` entram como chave quando o recurso de localização do nó/projeto está em uso — o texto continua sendo a chave, não a frase final.
- Ambiguidade resolve com **contexto**: `tr("Close", "Actions")` × `tr("Close", "Distance")` — a mesma palavra-fonte, traduções diferentes, sem contexto o tradutor chuta.
- **Plural é da engine**, não do seu `if (n > 1)`: use a pluralização oficial (`tr` com plural/traduções `.po`) — idiomas têm 1, 2, 3+ formas plurais com regras próprias. Inteiro negativo/float não é plural de contagem: trate como texto à parte.
- Números, datas e moedas se **formatam por idioma**, não por string montada: o que parece detalhe vira "1.5" × "1,5" na cara do jogador.

Detalhe de escrita em [references/escrita-localizavel.md](references/escrita-localizavel.md).

### 2. Arquivos de tradução (o pipeline)

- Traduções vivem em arquivos **importados** (CSV ou PO/Gettext, planilha é o formato de trabalho com tradutor) e **registrados** em Project Settings → Localization → Translations. Arquivo traduzido sem registrar não entra no jogo.
- Uma fonte de verdade por idioma (`pt-BR`, `en` para começar), gerada/editada a partir das chaves — chave órfã (tradução sem uso) e chave faltante se caçam por comparação entre os arquivos na revisão.
- Atualizou texto: reimporte e reteste nos dois idiomas. Tradução é conteúdo versionado como código, com revisão (quem traduz não é quem aprova jogando, quando houver equipe).

Pipeline completo em [references/pipeline-de-traducao.md](references/pipeline-de-traducao.md).

### 3. Idioma em runtime

- `TranslationServer.set_locale("pt-BR")` troca na hora; a interface aberta precisa **reagir** (reaplicar textos ao trocar — texto montado uma vez no `_ready` e nunca mais é o bug clássico de "mudei o idioma e metade ficou").
- Primeira execução: `OS.get_locale_language()` sugere, o fallback do projeto (`internationalization/locale/fallback`, padrão `en`) cobre o resto; a escolha do jogador salva e vence o automático depois.
- Persistência do idioma segue o padrão de configuração do pacote (salva com as outras configurações do jogador, por arquivo de settings — nunca dentro de tradução).

### 4. Recursos e fontes por idioma

- **Remaps**: Project Settings → Localization → Remaps troca recurso por idioma (placa/bandeira com texto, narração, imagem com palavra). O que é **texto renderizado em imagem** deveria ser Label sempre que der — remap é para o que não dá.
- **Fontes**: a fonte do jogo precisa ter os caracteres dos idiomas-alvo (acentos completos no pt-BR é o mínimo hoje; idioma futuro com outro alfabeto entra por **fonte fallback**, não trocando a fonte base). Texto com quadradinho (tofu) é defeito de fonte, não de tradução.
- **Pseudolocalização** (Project Settings avançado) infla e acentua os textos para testar espaço/caracteres **antes** de traduzir: rode com ela e quebre o layout agora, com a `godot-ui-ux` dimensionando pelo idioma longo (+30–40%).

## Verificação (nos dois idiomas, sempre)

- [ ] Trocar para en e para pt-BR **com o jogo aberto**: tudo muda, nada fica no idioma anterior.
- [ ] Nenhuma chave crua visível (`MENU_START` na tela = chave faltante) em nenhum dos dois.
- [ ] Frases com valores/plurais corretas nos dois idiomas (0, 1, 2 e muitos).
- [ ] Pseudolocalização rodada: nenhum layout quebrado, nenhum tofu.
- [ ] Termos consistentes (mesmo conceito, mesmo termo, nas duas línguas — glossário do projeto).

## Arquivos desta skill

| Arquivo | Conteúdo |
|---|---|
| [references/escrita-localizavel.md](references/escrita-localizavel.md) | Chaves, placeholders, contexto, plural e formatação por idioma |
| [references/pipeline-de-traducao.md](references/pipeline-de-traducao.md) | CSV/PO, registro no projeto, runtime, remaps, fontes e pseudolocalização |
| [templates/glossario-e-chaves.md](templates/glossario-e-chaves.md) | Glossário pt-BR/en e convenção de chaves do projeto |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de mudanças da skill |
