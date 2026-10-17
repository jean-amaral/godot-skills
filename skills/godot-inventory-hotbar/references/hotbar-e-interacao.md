# Hotbar e interação

## Hotbar vinculada (um item, dois lugares)

- Slot da hotbar guarda **referência à entrada** (ou ao id+regra de reposição), não uma cópia: consumiu o último, o slot esvazia nos dois lugares no mesmo sinal; pegou mais do mesmo, o slot volta a mostrar quantidade.
- Item equipável na hotbar: ativar **equipa** (não consome); consumível: ativar **usa**. O verbo do slot vem da família do item, e o slot mostra qual é (ícone de estado/cooldown), sem o jogador decorar.
- Seleção: um slot selecionado por vez, legível por forma/posição além de cor; trocar de slot é instantâneo, **usar** é outra ação (selecionar sem querer usar é o erro que a hotbar não pode cometer pelo jogador).
- Cooldown de uso/troca aparece no slot (varredura/número), sincronizado com o sistema que impõe o cooldown — hotbar não tem timer próprio divergente.

## Atribuição (como o item vai parar no slot)

| Dispositivo | Gesto |
|---|---|
| Mouse | Arrastar do inventário para o slot (ou clique com modificador definido) |
| Controle | Focar o item, "atribuir", focar o slot, confirmar — foco visível nos dois passos, cancelar devolve sem vínculo |
| Toque | Tocar e segurar / modo atribuir explícito; nunca arrasto fino obrigatório |

Desatribuir é ação própria (limpar slot) que **não larga nem consome** o item: vínculo some, entrada fica.

## Drag-and-drop sem armadilha

- Arrastar mostra fantasma do item, destaca alvos válidos (slot, grade, equipamento) e inválidos de formas distintas; soltar fora devolve ao lugar de origem — **sempre**, inclusive ao fechar a tela no meio do arrasto.
- Trocar por arrasto sobre item ocupado é troca (os dois mudam de lugar), não substituição silenciosa; na grade espacial, troca que não cabe é recusada com os dois parados.
- Grade espacial de verdade (rotação de item, formas irregulares) é decisão da entrevista sabendo o custo: só entre se o encaixe for parte do jogo, com validação de encaixe no sistema e operação recusada sem efeito parcial.

## Navegação e leitura (com a `godot-ui-ux`)

- Grade de foco do controle segue a geometria da grade visual (cima/baixo/esquerda/direita previsíveis, vizinho explícito nas bordas), com o item focado mostrando tooltip sem precisar "abrir" nada.
- Tooltip compara com o análogo equipado (diferenças com sinal e número, não só cor verde/vermelha); ação de cada botão aparece com o glifo do dispositivo atual.
- Ordenar/filtrar/buscar mudam a **apresentação**; a ordem do modelo só muda por operação (mover) — fechar e abrir não pode "reorganizar sozinho" o que o jogador arrumou, salvo "ordenar" explícito.

## Erros clássicos

- Hotbar como segundo inventário: item existe em dois lugares e o save acredita nos dois.
- Arrastar como único caminho: controle e toque viram cidadãos de segunda classe.
- Usar item pela tela (efeito aplicado na UI) e debitar depois: fechar a tela no meio usa sem pagar.
- Slot selecionado que usa no scroll sem querer durante o combate.

---
_Referência criada em 2026-10-17. Hotbar se testa em combate real cronometrado, não na tela parada do inventário._
