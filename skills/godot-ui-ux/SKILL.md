---
name: godot-ui-ux
description: Design e construção de HUD, menus e experiência do usuário (UI/UX) em jogos Godot 4.7+ — hierarquia de informação, layout que sobrevive a resolução e proporção, navegação por mouse/teclado/controle/toque, feedback, acessibilidade e testes de usabilidade, sempre a partir de pesquisa com referências. Use quando o criador pedir HUD, barra de vida, inventário, menu, tela de configurações, diálogo, tutorial, onboarding ou melhorar "a sensação" de qualquer interface do jogo.
---

# Godot UI/UX

Interface é gameplay traduzido em leitura: **pesquisa primeiro (jogo e interface de referência analisados), fluxo escrito, layout depois, teste com gente no fim**. HUD bonito que o jogador não lê em combate é enfeite caro; menu "simples" que o controle não navega é menu quebrado.

## Quando usar

- Criar ou refazer HUD: vida, recurso, mira, minimapa, objetivos, alertas, dano, interação.
- Criar menus e telas: principal, pausa, configurações, inventário, loja, diálogo, mapa, codex.
- Desenhar a experiência: onboarding, tutorial contextual, primeira sessão, curva de revelação de sistemas.
- Diagnosticar "a interface está confusa/feia/sem graça" e propor a correção com evidência, não com gosto.

Arquitetura de cena/gameplay continua em `godot-3d-specialist` (cuja referência [ui-de-jogo.md](../godot-3d-specialist/references/ui-de-jogo.md) cobre layout, listas e tema em runtime); esta skill é a camada de **design e experiência**. Menus de título/principal/pausa/configurações têm skill própria: `godot-game-menus`; inventário e hotbar (com entrevista de design): `godot-inventory-hotbar`. Acabamento visual/materiais: `godot-visual-craft`. Assets de UI gratuitos licenciados: `godot-free-assets`. Como pensar antes de criar: `agent-frontier-reasoning`.

## Protocolo de pesquisa (obrigatório, antes de desenhar)

1. **Tarefa antes de tela**: escreva a tarefa do jogador ("saber que vou morrer", "trocar a arma certa em 3 segundos", "entender o objetivo sem ler parágrafo"). Tela sem tarefa vira mural.
2. **Referências analisadas**: 2–3 jogos do mesmo gênero/pressão (combate não lê como menu), a obra de estilo do GDD e a documentação `Control`/`Theme` da versão do projeto. Extraia regras — hierarquia, agrupamento, posição, linguagem de estado — não copie arte.
3. **Análise mensurável**: o que aparece primeiro (teste dos 3 segundos), o que está agrupado e por quê, tamanho/contraste dos críticos, quantas ações levam à tarefa, como cada estado (normal/alerta/crítico) se distingue **sem depender só de cor**.
4. **Especificação antes do editor**: mapa de telas/fluxo + [templates/brief-de-tela.md](templates/brief-de-tela.md) preenchido (tarefa, hierarquia, estados, entradas, critérios de aceite). Sem brief, não abra a cena de UI.
5. **Comparação e teste**: captura lado a lado com a referência e teste de tarefa com quem não fez a tela. Quem aprova é o teste, não quem desenhou.

## Padrões por disciplina

### HUD

- Hierarquia por pressão: crítico e frequente mora na periferia do olhar (canto consistente), central é do mundo — ver [references/hud-e-hierarquia.md](references/hud-e-hierarquia.md) (zonas, agrupamento, estados, HUD contextual que some quando não serve).
- Estado se lê em camadas redundantes: posição/tamanho/ícone/texto **e** cor — nunca cor sozinha. Crítico pisca com teto (acessibilidade), não por tempo infinito.
- Feedback é imediato, localizado e com fim: dano, cura, recurso e erro respondem no elemento que mudou, com animação curta e som por hook — detalhe e orçamento em [references/feedback-e-estados.md](references/feedback-e-estados.md).
- HUD não decide gameplay: ele **apresenta** estado que o sistema publica por sinal/dado; regra de jogo dentro de `Control` é dívida.

### Menus e fluxos

- Um fluxo = uma intenção: entrar, continuar, ajustar, sair. Mapa de telas com entrada, saída, confirmação e **caminho de volta sempre visível** — [references/fluxos-e-onboarding.md](references/fluxos-e-onboarding.md).
- Toda tela tem os quatro estados desenhados: normal, vazio, carregando e erro. Tela que só existe no caminho feliz quebra no primeiro save vazio.
- Onboarding ensina jogando, uma ideia por vez, no contexto em que ela serve; texto de tutorial é a última opção, não a primeira.

### Layout e entrada (Godot)

- `Control` + âncoras + containers; `CanvasLayer` separa HUD de menu; um `Theme` com variações nomeadas — sem estilo solto por nó. Quebra aparece no menor tamanho e no ultrawide: teste os dois.
- Mouse, teclado, controle e toque são cidadãos do mesmo menu: foco inicial definido, ordem de foco testada **com o controle na mão**, vizinho explícito onde o container erra.
- Escala de UI é configuração do jogador sobre o tema; área segura de TV/console é margem, não esperança. Guia completo em [references/layout-e-entrada.md](references/layout-e-entrada.md).

### Acessibilidade (desde o brief, não como patch)

- Contraste e tamanho mínimo são orçamento do tema; daltonismo não se resolve "mudando o vermelho", resolve-se com forma/ícone/texto redundante.
- Remapeamento de entrada, reduzir tremor/flash/movimento de UI, legenda e escala de texto entram no desenho das configurações — checklist em [references/layout-e-entrada.md](references/layout-e-entrada.md).
- Localização desde a primeira tela: texto por chave, espaço para o idioma que expande, termo da engine em inglês.

## Verificação (antes de dizer "pronto")

- [ ] Teste dos 3 segundos: quem nunca viu a tela diz o que é crítico sem ajuda.
- [ ] Tarefas-chave cronometradas e sem erro com controle **e** com mouse/teclado.
- [ ] Menor resolução suportada, resolução-alvo, ultrawide e área segura conferidos em captura.
- [ ] Estados vazio/erro/carregando e texto mais longo de localização sem quebra.
- [ ] Contraste, tamanho mínimo, dependência de cor e foco visível revisados.
- [ ] Comparação com a referência registrada: diferença corrigida ou decisão escrita.

## Arquivos desta skill

| Arquivo | Conteúdo |
|---|---|
| [references/hud-e-hierarquia.md](references/hud-e-hierarquia.md) | Zonas de HUD, hierarquia, agrupamento, estados e HUD contextual |
| [references/fluxos-e-onboarding.md](references/fluxos-e-onboarding.md) | Mapa de telas, fluxos, onboarding e tutorial contextual |
| [references/layout-e-entrada.md](references/layout-e-entrada.md) | Âncoras/containers, Theme, foco, resoluções e acessibilidade |
| [references/feedback-e-estados.md](references/feedback-e-estados.md) | Feedback, microanimações, estados de elemento e orçamento de motion |
| [templates/brief-de-tela.md](templates/brief-de-tela.md) | Brief de tela: tarefa, hierarquia, estados, entradas e aceite |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de mudanças da skill |
