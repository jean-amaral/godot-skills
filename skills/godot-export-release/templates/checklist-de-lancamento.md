# Checklist de lançamento — <jogo> v<versão>

## Identidade

- [ ] Versão definida e igual no projeto, nos arquivos e na loja: `v<X.Y.Z>`
- [ ] Commit/tag da release: <hash> · Changelog do jogador escrito
- [ ] Ícone, nome e splash conferidos no build

## Portão de qualidade

- [ ] Fluxo principal jogado de ponta a ponta **no build exportado**
- [ ] Save/config/áudio persistem ao fechar e reabrir o build
- [ ] Performance medida no hardware-alvo (`godot-performance-testing`)
- [ ] Idiomas pt-BR + en conferidos na interface (`godot-localization`)

## Builds (do mesmo commit)

| Alvo | Preset | Arquivo | Rodou limpo fora do editor |
|---|---|---|---|
| Windows x86_64 | | | [ ] |
| Web (se alvo) | | | [ ] |
| Android (se alvo) | | | [ ] |

## Assinatura e segredos

- [ ] Assinatura aplicada onde o alvo pede (Windows/Android/macOS)
- [ ] Nenhum segredo no repositório; keystore/certificado com backup testado

## Loja/publicação

- [ ] Página com requisitos reais, idiomas declarados e capturas do build
- [ ] Arquivos por jogo-versão-plataforma; upload re-baixado e aberto
- [ ] Artefatos + commit da release arquivados para hotfix
