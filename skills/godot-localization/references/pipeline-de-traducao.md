# Pipeline de tradução (arquivos, runtime, fontes)

Fonte: tutoriais oficiais [Importing translations](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_translations.html) e [Internationalizing games](https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html) (Godot 4.7).

## Arquivos e registro

- Formatos importáveis: **CSV** (planilha: chave, pt-BR, en, …) e **PO/Gettext** (o formato de tradutores profissionais, com plural e contexto de primeira classe). Escolha um por projeto; misturar os dois para os mesmos idiomas vira divergência.
- Depois de importar, **registre** os arquivos em Project → Project Settings → **Localization → Translations**. Importar sem registrar é o "traduzi e não mudou nada" clássico.
- Tradução atualizada reimporta: o fluxo com tradutor externo é planilha vai → arquivo volta → reimporta → **retesta nos dois idiomas** (tamanho, plural, chave nova). Tradução não revisada em jogo é texto não revisado como outro qualquer.

## Chaves sob controle

- Gere/extraia a lista de chaves do código e das cenas e compare com os arquivos dos dois idiomas na revisão: faltante (aparece a chave crua) e órfã (tradução de chave que morreu) se resolvem nessa comparação, não no relato do jogador.
- Os idiomas obrigatórios do pacote (`pt-BR`, `en`) têm paridade: mesma lista de chaves nos dois arquivos, sempre. Idioma novo entra copiando a estrutura, não traduzindo "as telas principais".

## Runtime e troca de idioma

- `TranslationServer` é o servidor da engine: `set_locale()` troca, `get_locale()` lê, traduções podem entrar/sair em runtime (DLC de idioma é tecnicamente possível por aqui).
- Quem mostra texto precisa **ouvir a troca**: reaplique os textos ao mudar o idioma (reação à mudança nas telas abertas). Padrão do pacote: função única `refresh_texts()` por tela, chamada na abertura **e** na troca.
- Automático na primeira vez: `OS.get_locale_language()` + fallback do projeto (`internationalization/locale/fallback`); manual depois disso, salvo nas configurações do jogador junto das outras preferências.

## Recursos por idioma (remaps) e fontes

- **Remaps** (Localization → Remaps): recurso alternativo por locale — imagem com texto, voz, vídeo. Cadastre o recurso base e as variantes; a engine troca sozinha ao mudar o idioma.
- **Fonte não usa remap**: alfabeto diferente entra por **fallback de fonte** (cadeia de fontes), que funciona até com idioma misto na mesma tela (chat em multiplayer). A fonte base precisa, no mínimo, cobrir pt-BR/en completos (acentos, cedilha, travessão) — confira a ficha de caracteres antes de aprovar a fonte.
- Direitos: fonte de UI é asset — licença dela entra pela `godot-free-assets`/registro de créditos como qualquer outro.

## Pseudolocalização (testar antes de traduzir)

- Nas Project Settings avançadas, a pseudolocalização alonga e acentua os textos mantendo-os legíveis (placeholders preservados): serve para **quebrar o layout agora** e conferir cobertura de caracteres da fonte.
- Rode o jogo inteiro com ela (menus, HUD, diálogos longos) ao fechar cada tela nova — é o teste barato que substitui "descobrir no japonês". Não testa alfabeto/RTL de verdade: idioma com outra escrita pede teste próprio quando entrar.

---
_Referência criada em 2026-10-17 a partir da documentação oficial de i18n/importação de traduções da Godot 4.7._
