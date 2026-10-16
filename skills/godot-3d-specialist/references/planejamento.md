# Planejamento e estrutura do projeto 3D

## Estrutura de pastas sugerida

Adapte ao que o projeto já usa; esta é a referência quando não há convenção.

```text
res://
  docs/            # gdd.md, tdd.md, prop_catalog.md, diário de produção
  devlog/          # index.html, audit_report.json, screenshots/, timelapses/
  scenes/
    props/         # .tscn modulares e independentes
    environments/  # níveis montados a partir dos props
    characters/
    ui/
  scripts/
    components/    # HealthComponent, InteractionComponent, ...
    autoloads/     # GameState, SaveSystem, AudioBus, ...
    tools/         # @tool e scripts de auditoria (não entram no gameplay)
  resources/       # Resource customizados: itens, materiais, biomas
```

Regras:

- Cena de prop é autocontida: abre sozinha, sem depender do nível.
- Script em `scripts/tools/` nunca é referenciado por cena de gameplay.
- Dado de balanceamento vive em `Resource`, não hardcoded em cena.

## As 6 fases de produção

| Fase | Entrega | Critério de saída |
|---|---|---|
| 1. Concepção | GDD + TDD + grade métrica + lista de assets | Pilares e estilo visual aprovados |
| 2. Greyboxing | Nível em CSG/`GridMap` jogável com `CharacterBody3D` | Escala e fluxo validados andando pelo nível |
| 3. Vertical slice | Um trecho final: props modulares, luz base, 1 loop de gameplay | Representa a qualidade final do jogo |

Qualidade desde o protótipo: mesmo a Fase 2 já usa proporção real, material-base do estilo escolhido (padrão: realista) e luz de leitura. O vertical slice não é "quando fica bonito" — é quando o trecho que já nasceu apresentável prova o loop completo.
| 4. Produção | Todos os sistemas: IA, save/load, shaders, áudio 3D, UI | Feature-complete, sem placeholder funcional |
| 5. Polimento | Game feel, partículas, `MultiMeshInstance3D`, oclusão, LOD | Profiler dentro do orçamento de frame |
| 6. QA e export | Auditoria headless limpa + `export_presets.cfg` testado | Build exportado roda fora do editor |

Não pule a fase 2: trocar CSG por prop final sem validar escala com a cápsula do personagem é a origem mais comum de porta estreita e corredor apertado.

## Antes do GDD: a concepção

Se o conceito ainda não está fechado (ideia vaga, sem mecânica central),
o primeiro documento não é o GDD: é a **entrevista de concepção**
([concepcao-e-entrevista.md](concepcao-e-entrevista.md)), registrada em
[../templates/entrevista-concepcao.md](../templates/entrevista-concepcao.md).
Ela termina em conceito de uma frase, pilares com veto e a hipótese de
inovação que o greyboxing (Fase 2) precisa falsificar. GDD escrito antes
disso costuma documentar um jogo que muda na semana seguinte.

## GDD e TDD

- GDD: o que o jogador faz e sente. Use [../templates/gdd.md](../templates/gdd.md).
- TDD: como o código sustenta o GDD — arquitetura de cenas, autoloads, formato de save, orçamento de performance. Documento vivo: atualize na mesma entrega que muda o sistema.
- Catálogo de props: uma linha por prop com dimensões e pivô. Use [../templates/prop-catalog.md](../templates/prop-catalog.md).

## Roadmap rastreável

Cada tarefa do roadmap aponta para: fase, cena/script afetado e critério de pronto verificável (ex.: "auditoria com 0 erros", não "funciona"). Progresso do roadmap é o que alimenta o painel de fases do devlog HTML.


---

_Referência revisada em 2026-10-16 (Godot 4.7.2). A suíte `tests/` prova os scripts do pacote; as receitas daqui são orientação de uso, não comportamento testado. Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
