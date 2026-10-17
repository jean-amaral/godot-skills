# Layout, entrada e acessibilidade (Godot)

Design decide **o quê e onde**; esta folha garante que sobrevive à engine, à resolução e às mãos do jogador. A base técnica (containers, pooling, RichText) está em `godot-3d-specialist/references/ui-de-jogo.md` — aqui é o contrato de experiência sobre ela.

## Layout que sobrevive

- Hierarquia de `Control`: `CanvasLayer` (HUD abaixo de menus, menus abaixo de diálogo do sistema) → âncoras nos cantos/papel → containers para o miolo. Posição absoluta só em elemento livre (marcador, dano flutuante).
- Teste obrigatório em: menor resolução suportada, resolução-alvo, ultrawide e proporção de TV. O que quebra primeiro: texto longo, lista e rodapé.
- Texto é o elemento que mais quebra layout: dimensione pelo idioma mais longo esperado (+30–40%), não pelo português/inglês do protótipo.
- Um `Theme` do projeto com variações nomeadas (`ButtonDanger`, `LabelTitle`); cor/tamanho soltos por nó viram inconsistência impossível de auditar. Troca de tema/escala reaplica em runtime, sem reiniciar cena.

## Entrada: quatro cidadãos, um menu

| Entrada | Contrato |
|---|---|
| Mouse | Hover distinto de foco; alvo clicável com tamanho mínimo confortável; nada essencial só em hover |
| Teclado | Toda ação com atalho visível onde ajuda; Esc/B volta; Tab/setas navegam |
| Controle | Foco inicial em toda tela, ordem testada jogando, vizinho explícito onde o container erra, foco **sempre visível** |
| Toque | Alvo generoso, sem gesto escondido para ação essencial, sem depender de hover |

- Ação se confirma pelo dispositivo em uso: prompt mostra o glifo do controle/tecla atual (remapeado!), nunca um "pressione X" fixo de outro dispositivo.
- Remapeamento com detecção de conflito e "restaurar padrões"; ação essencial nunca fica sem tecla por acidente.

## Acessibilidade (orçamento, não favor)

- **Texto**: tamanho mínimo definido no tema, escala do jogador (ex.: 100–150%) sem quebrar layout testado.
- **Contraste**: texto e estado crítico legíveis sobre o cenário mais claro e o mais escuro onde aparecem; valide em captura, não na amostra de cor.
- **Cor**: nunca a única portadora de estado (ver [hud-e-hierarquia.md](hud-e-hierarquia.md)); ofereça modo/daltonismo quando o jogo usa cor como código central.
- **Movimento**: reduzir/pulsar flashes, tremor de tela e microanimações decorativas é configuração respeitada por HUD e menus.
- **Som**: informação crítica tem canal visual redundante; legenda identifica quem fala e sons relevantes fora de cena quando o design promete isso.
- **Tempo**: nada essencial some antes de poder ser lido; QTE/leitura sob pressão têm ajuste de dificuldade/velocidade quando o gênero permite.

## Erros clássicos

- Foco que nasce em "Sair" e Enter acidental fecha o jogo.
- Prompt de controle em jogo sendo jogado no teclado (e vice-versa).
- Escala de UI testada só no monitor do desenvolvedor.
- Acessibilidade como tela separada no fim do projeto, quando o tema já travou tamanhos.

---
_Orientação revisada em 2026-10-17 para Godot 4.7+. Confira nós/propriedades na documentação da versão do projeto antes de aplicar._
