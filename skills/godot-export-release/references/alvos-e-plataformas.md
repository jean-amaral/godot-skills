# Alvos e plataformas (documentação oficial de export)

Fonte: [Exporting projects](https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html) e páginas `exporting_for_*` da Godot 4.7. Exigência de SDK muda com a plataforma: confirme na página do alvo, na versão da engine do projeto.

## A base comum

- **Export templates** instalados na **mesma versão** do editor (o export empacota o jogo com o binário-template otimizado, sem editor/debugger). Atualizou a engine, atualize os templates — e re-exporte tudo.
- **Preset** por alvo no `export_presets.cfg` versionado; export pela CLI para repetir:

```text
godot --headless --export-release "Windows Desktop" build/windows/meu-jogo.exe
godot --headless --export-debug   "Windows Desktop" build/windows/meu-jogo-debug.exe
```

- Nome de saída é convenção do projeto: `jogo-versao-plataforma` — quem baixa dois builds precisa saber qual é qual sem abrir.

## Windows (a base de PC)

- Arquitetura **x86_64** por padrão (arm64 só como build adicional declarado; x86_32 é legado sem suporte da Microsoft — não use como padrão).
- Saída: executável + `data.pck` (ou PCK embutido até ~3,89 GB somados). Ícone do projeto vira `.ico` automaticamente; controle fino é criando o ICO manualmente (página oficial do ícone).
- Assinatura automática na exportação com Windows SDK (ou `osslsigncode` fora do Windows) + seu certificado: ver [publicacao-e-lojas.md](publicacao-e-lojas.md).

## Web (HTML5)

- Exige o renderizador de **compatibilidade** no projeto (projeto em Forward+ não vira web por mágica de preset: decida cedo se web é alvo, porque ela limita o visual — `godot-visual-craft`/`godot-3d-specialist` precisam saber).
- Sem ENet/UDP cru: rede web é WebSocket/WebRTC (a skill `godot-multiplayer` já separa esse caso); threads e recursos variam por hospedagem (COOP/COEP quando aplicável) — teste **hospedado**, não só local.
- Persistência é do navegador (save por IndexedDB/cookies conforme a engine expõe): valide save cedo no navegador-alvo.

## Android

- Pré-requisitos da plataforma (SDK/JDK/Gradle conforme a página oficial vigente) resolvidos **antes** do dia do lançamento; a janela de export aponta o que falta.
- Assinatura: debug para testar no aparelho, **release com sua keystore** para publicar — guarde a keystore fora do git, com backup testado (perder = nunca mais atualizar o app).
- Formatos de textura/compressão são por dispositivo no mobile (a doc de export explica ETC2 etc.): o que roda liso no PC pode pesar no telefone — performance se mede no aparelho (`godot-performance-testing`).

## Outros desktops (Linux/macOS)

- Linux segue o modelo Windows (executável + pck). macOS soma as exigências da Apple (assinatura/notarização para distribuir fora da loja sem atrito) — trate como pré-requisito nomeado da release, não descoberta no dia.

## Erros clássicos

- Exportar com template de versão diferente "porque o editor não reclamou alto".
- Testar só no editor e descobrir no jogador o recurso que não foi junto.
- Web como alvo surpresa no fim do projeto em Forward+.
- Keystore/senha dentro do repositório ou só num laptop sem backup.

---
_Referência criada em 2026-10-17 a partir da documentação oficial de export da Godot 4.7. Exigências de SDK/assinatura mudam: confira a página do alvo na release._
