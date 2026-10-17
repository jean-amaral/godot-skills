---
name: godot-inventory-hotbar
description: Criação de inventário e hotbar (barra de itens rápidos) em jogos Godot — começando por uma entrevista de design com o criador (modelo, limites, itens, interação), modelo de dados por Resource/id, operações seguras, hotbar vinculada, arrastar-e-soltar e navegação por controle, save e multiplayer. Use quando o criador pedir inventário, mochila, baú, equipamentos, loot, itens ou hotbar/barra de atalhos em jogo 2D ou 3D.
---

# Godot Inventory & Hotbar

Inventário é **sistema de jogo vestido de interface**: o modelo errado (grade onde devia ser peso, hotbar que duplica item) cobra juros em save, balanceamento e multiplayer para sempre. Por isso esta skill começa com **entrevista**, continua com pesquisa e só então constrói.

Companheiras: experiência/layout em `godot-ui-ux`; itens como dado em `godot-engine-resources` (`Resource`) e no padrão data-driven da `godot-3d-specialist`; menus/slots de save em `godot-game-menus`; rede em `godot-multiplayer`.

## Pesquisa sempre (regra do pacote)

Antes de criar ou alterar, pesquise informações e referências atuais: como os jogos de referência do gênero resolvem inventário/hotbar (**vídeo jogando de verdade**, não só captura da tela), a documentação oficial da versão e as regras da `godot-ui-ux` — e transforme em especificação antes de executar. Método completo: `agent-frontier-reasoning`. Sem internet, declare o que ficou não verificado.

## Passo 1 — Entrevista (obrigatória, antes de qualquer código)

Inventário tem dez decisões que mudam tudo e **não se deduzem do gênero sozinhas**. Conduza a entrevista de [references/entrevista-de-inventario.md](references/entrevista-de-inventario.md):

- **Uma pergunta decisiva por vez**, com a recomendação e o porquê apresentados. Nada de rajada de perguntas nem formulário frio.
- **Não pergunte o que dá para descobrir** (leia GDD, projeto, referências citadas antes).
- **Decisão se escreve na hora** no registro ([templates/especificacao-de-inventario.md](templates/especificacao-de-inventario.md)), como **Rascunho** até o aceite explícito virar contrato.
- Sem resposta para uma decisão, vale a **recomendação padrão registrada como suposição** — nunca trave o projeto por uma pergunta, nunca esconda que supôs.

A entrevista fecha: papel do inventário no jogo, modelo (lista/grade/slots/peso), regras de item, hotbar, interação por dispositivo e o que acontece quando enche.

## Passo 2 — Modelo (sistema antes de tela)

- **Definição × instância**: item é `Resource` com `id` estável, nome/ícone por chave localizada (`godot-localization`), regras (empilhável e teto, equipável e slot, consumível, único). O inventário guarda **entradas** (`{id, quantidade}` ou instância com estado: durabilidade, encantamento), nunca o Resource em si.
- **Operações são funções do sistema**, não da UI: `adicionar` (respeitando pilha/limite, devolvendo o que **não coube**), `remover`, `mover/trocar`, `dividir/juntar pilha`, `equipar/desequipar` — atômicas, com resultado que a apresentação só mostra. Sinal a cada mudança para HUD/hotbar/save reagirem.
- **Limite é regra nomeada** (slots, peso, grade espacial ou ilimitado declarado) com comportamento de cheio desenhado: recusar e avisar, largar no chão ou transbordar — nunca perder item em silêncio.
- **Save guarda ids e números** (o contrato do pacote); item único guarda seu estado próprio ao lado do id. Em rede, a autoridade decide inventário que importa (`godot-multiplayer`): cliente apresenta, servidor concede.

Detalhe em [references/modelo-e-operacoes.md](references/modelo-e-operacoes.md).

## Passo 3 — Hotbar (a parte que se usa jogando)

- Hotbar é **atalho para entradas do inventário**, não um segundo inventário: usar/equipar pela hotbar consome/move a mesma entrada (item que acaba some dos dois lugares ao mesmo tempo).
- Quantidade de slots vem da entrevista (teclas 1–9, roda do mouse, ombros do controle, roda radial quando o gênero pede) e **trocar não pausa o mundo** salvo decisão registrada. Seleção visível sem depender só de cor, cooldown/estado no próprio slot.
- Arrastar para a hotbar (mouse) e atribuir por foco+botão (controle) são o mesmo vínculo por baixo. Detalhe em [references/hotbar-e-interacao.md](references/hotbar-e-interacao.md).

## Passo 4 — Apresentação (a tela obedece ao sistema)

- Grade/lista é `Control` com células reutilizadas (pooling) para inventário grande; arrastar-e-soltar com fantasma, alvo válido destacado e **cancelar devolvendo ao lugar**; tooltip compara com o equipado; raridade nunca é só cor (ícone/forma/texto junto, `godot-ui-ux`).
- Controle navega por grade de foco de verdade (não emule mouse com analógico como único caminho); toque tem alvo generoso e ação sem arrasto obrigatório.
- Abrir inventário pausa ou não? Decisão da entrevista, aplicada à árvore inteira (mundo, timers, rede) — não à tela.

## Verificação

- [ ] Entrevista registrada e aceita (ou suposições declaradas) antes do código.
- [ ] Encher até o limite: nada se perde em silêncio; pilhas dividem/juntam certo.
- [ ] Hotbar usa e esgota item refletindo no inventário (e vice-versa) no mesmo instante.
- [ ] Salvar, fechar, reabrir: inventário idêntico (ids, quantidades, estados, hotbar).
- [ ] Só de controle: abrir, mover, atribuir hotbar, usar e fechar sem mouse.
- [ ] Referência do gênero comparada em vídeo: o que foi extraído está na especificação.

## Arquivos desta skill

| Arquivo | Conteúdo |
|---|---|
| [references/entrevista-de-inventario.md](references/entrevista-de-inventario.md) | A entrevista: contrato, fases, perguntas decisivas e recomendações padrão |
| [references/modelo-e-operacoes.md](references/modelo-e-operacoes.md) | Definição × instância, operações, limites, save, loot e multiplayer |
| [references/hotbar-e-interacao.md](references/hotbar-e-interacao.md) | Hotbar vinculada, atribuição, drag-and-drop e navegação por controle/toque |
| [templates/especificacao-de-inventario.md](templates/especificacao-de-inventario.md) | Registro da entrevista e especificação do inventário/hotbar |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de mudanças da skill |
