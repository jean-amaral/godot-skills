---
name: godot-export-release
description: Exportar e publicar jogos Godot 4.7+ a partir da documentação oficial — export templates e presets, export por linha de comando/headless, alvos Windows/Web/Android/desktop, PCK/DLC, assinatura, versionamento e checklist de lançamento (itch.io/Steam/direto). Use quando o criador pedir build, export, publicar, lançar, preparar demo ou distribuir o jogo para jogadores.
---

# Godot Export & Release

Jogo pronto que não chega ao jogador é protótipo caro. Export é um **pipeline repetível e verificado**, não um clique na véspera: templates certos, preset versionado, build testada fora do editor e checklist de loja.

Base oficial: [Exporting projects](https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html) e as páginas por plataforma da documentação da Godot 4.7. Produção/qualidade dentro do jogo: referência de produção da `godot-3d-specialist`. Testes e performance do build: `godot-performance-testing`.

## Antes de exportar (o portão)

1. **Versão e identidade fechadas**: número de versão do jogo (config do projeto), ícone, nome, e o que esta build **é** (demo, EA, 1.0) escrito no changelog. Build sem identidade vira "final2_novo_agora_vai.zip".
2. **O jogo passa no portão de qualidade**: roda do zero sem erro, save/áudio/configurações funcionam, performance medida no hardware-alvo (`godot-performance-testing`) e localização mínima conferida (`godot-localization`: pt-BR + en).
3. **Export templates da mesma versão da engine** instalados — template de outra versão é a causa nº 1 de "export quebrado sem explicação".

## Presets: a decisão versionada

- Um preset por alvo real (`export_presets.cfg` **no versionamento**, revisado como código): Windows x86_64 como base de PC; Web e Android só com suas exigências próprias atendidas (abaixo). Preset que só existe na máquina de quem exporta não é pipeline.
- Templates e SDKs por alvo são pré-requisitos nomeados (a própria janela de export avisa o que falta — resolva o aviso, não contorne).
- Opções que mudam o produto (ícone, tela de splash, recursos incluídos/excluídos, PCK embutido × separado) são decisão registrada no preset, não clique esquecido. No Windows: PCK embutido tem teto (~3,89 GB com o executável); jogo grande é executável + `.pck` separado.

## Exportar de verdade

| Via | Quando |
|---|---|
| Editor (Export → preset → Export Project) | Build manual, protótipo para teste interno |
| Linha de comando (`godot --headless --export-release "<Preset>" <saida>`) | Pipeline repetível/CI, várias plataformas, build de lançamento — a forma que se audita |

- Depois de exportar, **teste o build exportado** (não o editor): descompacte numa pasta limpa, rode, jogue o fluxo principal, feche e reabra (save persiste?), desinstale mentalmente o editor da máquina. Erro que só aparece no export (recurso faltando, caminho `res://` presumido, debug ligado) é exatamente o que este passo existe para pegar.
- `--export-debug` × `--export-release`: release é o que vai ao jogador (sem debugger, otimizado); debug exportado serve para testar no alvo com depuração — não confunda os dois na entrega.

Detalhes por alvo em [references/alvos-e-plataformas.md](references/alvos-e-plataformas.md); empacotamento/versão/loja em [references/publicacao-e-lojas.md](references/publicacao-e-lojas.md).

## Assinatura e confiança

- Windows: a Godot assina na exportação com Windows SDK/`osslsigncode` + certificado seu; sem assinatura, o Windows assusta o jogador (SmartScreen) — para distribuição séria, certificado é pré-requisito, não enfeite.
- Android: assinatura de release (keystore guardada **fora** do repositório, com backup — keystore perdida = app órfão para sempre).
- Nunca versione segredos: keystore, senha e chaves de loja ficam fora do git, sempre.

## Checklist de lançamento (resumo — completo no template)

- [ ] Build de cada alvo gerada do mesmo commit, com versão igual em todas.
- [ ] Cada build rodada limpa fora do editor, fluxo principal completo.
- [ ] Ícone/nome/splash certos; nada de debug/dev visível ao jogador.
- [ ] Página da loja com requisitos, capturas do **build**, idiomas declarados (pt-BR + en no mínimo, `godot-localization`).
- [ ] Arquivos nomeados por jogo-versão-plataforma; checksum/tamanho conferidos após upload (re-baixe e abra).

Modelo em [templates/checklist-de-lancamento.md](templates/checklist-de-lancamento.md).

## Arquivos desta skill

| Arquivo | Conteúdo |
|---|---|
| [references/alvos-e-plataformas.md](references/alvos-e-plataformas.md) | Templates, presets e exigências por alvo (Windows, Web, Android, desktop) |
| [references/publicacao-e-lojas.md](references/publicacao-e-lojas.md) | PCK/DLC, versionamento, assinatura e publicação em itch.io/Steam/direto |
| [templates/checklist-de-lancamento.md](templates/checklist-de-lancamento.md) | Checklist completo de build e lançamento |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de mudanças da skill |
