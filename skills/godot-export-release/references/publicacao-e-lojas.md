# Publicação, PCK e lojas

## Empacotamento (PCK é o formato do jogo)

- Export gera o binário + dados em `.pck`. PCK separado permite atualizar/DLC trocando pacote; embutido simplifica distribuição pequena (com o teto do Windows). A Godot exporta **PCKs extras** (DLC/pacotes de conteúdo) com presets próprios — conteúdo adicional é pacote versionado, não pasta solta copiada pelo jogador.
- O que vai dentro é decisão: recurso de desenvolvimento (cena de teste, devlog, fonte crua) fora do build do jogador — tamanho e vazamento se controlam no preset/projeto, não na mão depois.

## Versionamento da release

- Uma release = um commit + uma versão, aplicados a **todos** os alvos. Changelog do jogo (o que mudou para o jogador) separado do changelog técnico das skills.
- Nome de arquivo final: `jogo-vX.Y.Z-plataforma.ext` igual em disco, na loja e no anúncio. Divergência aqui vira suporte eterno ("qual build você baixou?").

## Assinatura e confiança por alvo

| Alvo | O que assina | Armadilha |
|---|---|---|
| Windows | Executável (Windows SDK/`osslsigncode` + certificado) | Sem assinatura: SmartScreen assusta; autocertificado não resolve para o público |
| Android | APK/AAB com sua keystore de release | Perder a keystore = app órfão; keystore no git = app sequestrável |
| macOS | App + notarização Apple | Distribuir sem notarizar = bloqueio no Mac do jogador |
| Web | — (hospedagem é a confiança) | Hospedar sem testar no ar: cabeçalhos/threads só aparecem hospedado |

Segredo (certificado, senha, chave) **nunca** entra no repositório: variável de ambiente/CI ou cofre local, com dono e backup nomeados.

## Lojas e distribuição direta

- **itch.io** (o caminho indie padrão): uma página por jogo, um canal/arquivo por plataforma nomeados pela convenção acima, página declarando idiomas (pt-BR + en) e requisitos reais — testados, não aspirados.
- **Steam**: build via pipeline da loja a partir dos mesmos artefatos versionados daqui (depot por plataforma); página/cápsulas e revisão têm prazos próprios — comece a página antes da build final, não depois.
- **Direto** (site/próprio): arquivo + checksum publicado; quem baixa confere, você prova que o upload não corrompeu (re-baixe e abra a cópia da loja/servidor).
- Em todas: capturas e trailer saem do **build exportado**, no hardware/preset do jogador — captura de editor em Forward+ vendendo build web de compatibilidade é propaganda enganosa acidental.

## Depois de publicar (a release continua)

- Guarde os artefatos e o commit da release: hotfix se faz da tag/commit exato, não do estado atual da `main`.
- Monitore os primeiros relatos com a versão na mão do jogador (a pergunta "qual build?" resolve metade).
- Patch é nova release com novo número — nunca substitua arquivo publicado em silêncio mantendo a versão.

---
_Orientação criada em 2026-10-17 a partir da documentação oficial de export/PCK da Godot 4.7 e do fluxo de lojas. Regras de loja mudam: confira as vigentes ao publicar._
