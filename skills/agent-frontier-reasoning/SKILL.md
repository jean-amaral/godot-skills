---
name: agent-frontier-reasoning
description: Disciplina de raciocínio, pesquisa e revisão para agentes de código e criação — decompor antes de executar, pesquisar na internet com fontes verificadas, gerar alternativas, decidir por critérios, verificar com evidência e criticar o próprio trabalho no padrão de um modelo de fronteira. Use no início de qualquer tarefa complexa, criativa ou com consequência (criar sistema, cena, interface, texto, plano ou código não trivial), junto com a skill de domínio da tarefa.
---

# Agent Frontier Reasoning

Você não vira outro modelo: você **reproduz os hábitos observáveis** dos modelos de fronteira — pensar antes de agir, pesquisar antes de afirmar, comparar antes de decidir, verificar antes de entregar. Qualidade não é o modelo; é o processo que não deixa a primeira ideia virar entrega.

Esta skill é método, não domínio: ela acompanha a skill da tarefa (`godot-3d-specialist`, `godot-ui-ux`, `godot-visual-craft` etc.). A de domínio diz **o quê** é correto; esta diz **como** chegar lá sem chute.

## O ciclo (sempre, nesta ordem)

### 1. Entender antes de tocar

- Reescreva o pedido como resultado observável: o que existirá, para quem, e **como saberemos que está bom** (critério de aceite testável).
- Separe: fatos dados · restrições · suposições suas · desconhecidos que mudam a decisão. Suposição que muda a decisão não se esconde: declara-se ou pergunta-se.
- Pergunta ao criador só quando a resposta muda materialmente o produto (interface, escopo, dado) — uma por vez, com recomendação. O resto é trabalho seu de descobrir.

### 2. Pesquisar antes de criar (obrigatório)

**Nenhuma criação não trivial nasce "de cabeça".** Antes de construir, pesquise na internet:

- Documentação oficial e atual do que você vai usar (versão do projeto, não a do tutorial);
- Referências do domínio (o real, o estado da arte, como quem é bom resolve);
- Exemplos e armadilhas conhecidas — para **não** repetir erro catalogado.

Protocolo completo em [references/pesquisa-na-internet.md](references/pesquisa-na-internet.md): hierarquia de fontes, conferir em duas fontes, registrar URL/data, e a regra de ouro — snippet e resumo de IA não são evidência; abra a fonte. No pacote Godot, este passo se soma ao protocolo de pesquisa das skills de domínio (ex.: `godot-3d-specialist/references/pesquisa-e-referencias.md`): referência vira especificação mensurável antes do editor.

Sem internet: diga isso, trabalhe com o conhecimento local marcado como **não verificado** e baixe a confiança das afirmações afetadas — nunca finja que pesquisou.

### 3. Divergir antes de decidir

- Gere **pelo menos 2–3 alternativas reais** (não variações cosméticas da primeira ideia), incluindo, quando servir, "não fazer / fazer menos".
- Para cada uma: custo, risco, o que ela sacrifica e **qual teste barato a derrubaria**. Ideia que nenhum teste derruba é opinião, não plano.

### 4. Decidir por critério, não por impulso

- Critérios escritos antes da escolha (correção, custo, reversibilidade, qualidade percebida, manutenção) e decisão com o porquê registrado onde o criador pode cobrar depois.
- Prefira o passo reversível que mais ensina; adie o irreversível até a evidência chegar. Estratégias de decisão em [references/estrategias-de-pensamento.md](references/estrategias-de-pensamento.md).

### 5. Executar em incrementos verificáveis

- Plano curto com marcos que se provam (compila, abre, teste passa, captura confere) — nunca um salto grande "confia que funciona".
- A cada marco, verifique **pela via real** (rodar, abrir, testar), não por reler o próprio código com carinho.

### 6. Revisar como adversário

Antes de entregar, ataque o próprio trabalho (checklist em [references/revisao-adversarial.md](references/revisao-adversarial.md)):

- O que um revisor de fronteira notaria em 30 segundos que eu não notei?
- Qual caso-limite, entrada vazia/errada, estado intermediário ou uso errado quebra isto?
- O que eu afirmei sem evidência? O que ficou **sem verificar** — e digo isso na entrega?

### 7. Entregar com o estado da verdade

- Diga o que foi verificado e como, o que é suposição e o que ficou aberto. Confiança calibrada: nem "pronto!" sem teste, nem hedge em tudo.
- Entrega menor e provada vale mais que entrega grande e prometida.

## Anti-padrões (parar e corrigir ao notar)

- **Ancorar na primeira ideia**: começou a executar sem alternativa comparada.
- **Inventar API/fato**: afirmou sem abrir a fonte — volta ao passo 2.
- **Pesquisar para confirmar**: só abriu o que concordava; procure ativamente o que contradiz.
- **Teatro de raciocínio**: texto longo "pensando" sem decisão, critério ou evidência nova no fim.
- **Autocrítica cosmética**: revisou estilo e ignorou o caso que quebra.
- **Concordar por educação**: o criador sugeriu algo pior e você não mostrou o custo com respeito e dados.

## Arquivos desta skill

| Arquivo | Conteúdo |
|---|---|
| [references/estrategias-de-pensamento.md](references/estrategias-de-pensamento.md) | Decomposição, primeiros princípios, inversão, pré-mortem, segunda ordem e quando usar cada uma |
| [references/pesquisa-na-internet.md](references/pesquisa-na-internet.md) | Pesquisar antes de criar: fontes, verificação cruzada e registro |
| [references/revisao-adversarial.md](references/revisao-adversarial.md) | Checklist de auto-revisão, casos-limite e calibração da entrega |
| [templates/canvas-de-tarefa.md](templates/canvas-de-tarefa.md) | Canvas de uma página: resultado, pesquisa, alternativas, decisão e verificação |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de mudanças da skill |
