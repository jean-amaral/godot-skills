# Depuração (ferramentas oficiais)

## A receita antes da ferramenta

Bug bom de caçar tem: **ambiente** (build/editor, versão, cena), **passos numerados**, **esperado × obtido** e **frequência** (sempre/às vezes/uma vez). "Às vezes" pede o que varia entre as vezes (tempo, ordem, rede, aleatório sem seed — a `godot-engine-resources` manda seed registrada justamente para este dia).

## Debugger do editor (o que ele já faz)

- **Breakpoints** no script (clique na margem/F9) e pausa com pilha e variáveis inspecionáveis; **step** sobre/para dentro/para fora para ver o valor nascer errado, não o estrago depois.
- **Depuração remota**: o jogo rodando (inclusive exportado debug) se inspeciona pelo Debugger — árvore viva, nós e propriedades em tempo real, sem rebuildar com prints.
- **Painéis que mandam**: Output (prints/erros), Debugger > Errors (linhas vermelhas/amarelas com origem), Monitors (ver [otimizacao.md](otimizacao.md)), Video RAM (texturas/malhas e seu custo).
- Erro de parse/reload ou de `@tool`/EditorPlugin: a verdade está no Debugger/Output — via MCP, `logs_read` com `source="editor"` (skill `godot-ai-mcp`). Corrigiu? Confirme **na mesma fonte** que o erro sumiu.

## Estratégias quando o breakpoint não basta

- **Bisseção de cena/sistema**: desative metade dos suspeitos (processamento, sinais, spawns) e meça em qual metade o defeito mora; repita até a caixa ser pequena.
- **Bisseção de histórico**: funcionava — `git bisect`/diff entre o commit bom e o ruim acha o trecho antes de qualquer teoria (nunca reescreva histórico procurando: leia).
- **Estado, não sintoma**: imprima/inspecione as **variáveis da decisão** (estado, velocity, autoridade em rede) no instante da decisão — o sintoma (sprite errado) está a três sistemas de distância da causa.
- **Heisenbug** (some ao depurar): suspeite de tempo/ordem — física × processo visual, `await` em objeto liberado, sinal emitido durante a física. Logs com carimbo de frame/física revelam a ordem real.

## Higiene

- `print` de depuração com etiqueta única e removível; nada de print por frame no jogo entregue (custo e ruído).
- `push_warning`/`push_error` para o que o projeto quer ver no Debugger com origem, em vez de print solto.
- Defeito fechado sem receita virando teste (quando testável) volta no próximo refactor — a regressão é o preço de não registrar.

---
_Orientação criada em 2026-10-17 a partir da documentação oficial (Debugger, classe `Performance`). Nome de painel/monitor: confira na versão do editor em uso._
