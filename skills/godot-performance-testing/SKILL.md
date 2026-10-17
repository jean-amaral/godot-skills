---
name: godot-performance-testing
description: Depuração, profiling, otimização e testes em jogos Godot 4.7+ a partir da documentação oficial — Debugger e monitores Performance, breakpoints e inspeção remota, orçamento de frame/física/render, otimizações com medição (pooling, MultiMesh, servidores) e suítes de teste automatizadas. Use quando o criador relatar travamento, queda de FPS, vazamento, bug difícil de reproduzir, ou pedir testes/qualidade antes de lançar.
---

# Godot Performance & Testing

Performance sem medição é superstição; bug sem reprodução é opinião. Esta skill é o método: **reproduzir, medir, mudar uma coisa, medir de novo** — com as ferramentas oficiais da engine (Debugger, monitores `Performance`, profilers) e testes que rodam sozinhos.

Base oficial: classe [`Performance`](https://docs.godotengine.org/en/stable/classes/class_performance.html) e o Debugger da documentação da Godot 4.7. Suítes das skills do pacote ficam em `skills/<skill>/tests/`; testes via MCP em `godot-ai-mcp` (`test_run`).

## Depuração (achar o bug antes de chutar)

1. **Reproduza com receita**: passos mínimos, estado inicial, o que era esperado × o que acontece. Sem receita, não há bug — há um boato.
2. **Leia o erro de verdade**: Output/Debugger do editor, ou `logs_read` (`source="editor"`) via MCP. A primeira linha do erro manda; o resto é consequência.
3. **Isole por bisseção**: desligue metades (sistema, cena, sinal) até o defeito ficar numa caixa pequena. Breakpoints e inspeção de variáveis no Debugger (incl. depuração remota do jogo rodando) antes de encher o código de `print`.
4. **`print` com etiqueta e prazo**: log que fica no jogo é ruído e custo — marcador único, removido ao fechar o defeito (ou promovido a log de verdade, com nível).

Detalhe em [references/depuracao.md](references/depuracao.md).

## Profiling (medir antes de otimizar)

- **Orçamento primeiro**: frame-alvo (60 fps = 16,6 ms; 30 = 33,3 ms) dividido entre física, processo (scripts), render e espera — sem orçamento, "otimizar" é andar em círculo.
- **Monitores oficiais**: `Performance.get_monitor()` (FPS, tempos de processo/física/render, draw calls, primitivas, memória, objetos/nós/physics bodies) — os mesmos do painel Monitor do Debugger. Monitor customizado do seu jogo com `add_custom_monitor` (inimigos ativos, projéteis vivos) aparece junto no Debugger.
- **Profiler do Debugger** para achar **qual função** come o tempo; monitor diz "está pesado", profiler diz "quem". Capture a cena pesada real (pior caso jogável), não o menu.
- **Regra de ouro**: otimize o maior item medido, um por vez, medindo antes/depois no mesmo cenário salvo. Otimização sem número antes/depois é mudança de código com esperança.

Otimizações típicas com dono (pooling, MultiMesh, culling, servidores/RID, física enxuta) em [references/otimizacao.md](references/otimizacao.md).

## Testes (o que roda sozinho não regride)

| Camada | O que prova | Como no pacote |
|---|---|---|
| Suíte da skill/projeto (headless) | Scripts e contratos isolados | `tests/run_tests.ps1` (Godot 4.7+ via `GODOT_PATH`) — rode antes de publicar mudança em `scripts/`/`shaders/` |
| Teste via MCP | Suites GDScript dentro do editor vivo | `test_run`/`test_manage` da `godot-ai-mcp` (`McpTestSuite`) |
| Teste de fumaça manual roteirizado | Fluxo principal ponta a ponta | Roteiro curto no checklist de lançamento (`godot-export-release`) |
| Regressão de bug | O defeito que já aconteceu não volta | Cada bug sério vira um caso na suíte antes do conserto ser aceito |

- Teste que só passa na sua máquina (depende de ordem, tempo real, caminho absoluto) é teste quebrado esperando a CI. Determinismo: seed fixa, tempos simulados, caminhos relativos.
- Teste a falha também: entrada vazia/errada, save corrompido, cena faltando — o caminho feliz já é testado jogando.

## Verificação desta skill (antes de dizer "resolvido")

- [ ] Bug: receita de reprodução falha antes e passa depois (mesma receita!).
- [ ] Performance: número antes × depois no mesmo cenário, no hardware-alvo ou declarado.
- [ ] Suítes relevantes rodadas e verdes; o que não rodou, declarado (ex.: sem Godot local).

## Arquivos desta skill

| Arquivo | Conteúdo |
|---|---|
| [references/depuracao.md](references/depuracao.md) | Reprodução, Debugger/breakpoints, inspeção remota e leitura de erros |
| [references/otimizacao.md](references/otimizacao.md) | Orçamento de frame, monitores/profiler e otimizações medidas por sistema |
| [templates/relato-de-problema.md](templates/relato-de-problema.md) | Relato de bug/perf: receita, medição, hipótese e verificação |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de mudanças da skill |
