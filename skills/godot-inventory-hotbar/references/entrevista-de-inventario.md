# Entrevista de inventário e hotbar

Use quando o inventário ainda não está decidido no GDD — ou está decidido "por costume" ("todo RPG tem grade") sem ninguém ter escolhido de verdade. Se a especificação já existe e foi aceita, pule para o modelo.

## Contrato da entrevista (o mesmo da entrevista de concepção do pacote)

1. **Uma pergunta decisiva por vez**, com a recomendação e o porquê antes. O criador escolhe, altera ou discute.
2. **Não pergunte o que dá para descobrir**: GDD, protótipo, jogos citados e respostas anteriores se leem antes.
3. **Decisão se escreve na hora** em [templates/especificacao-de-inventario.md](../templates/especificacao-de-inventario.md), como **Rascunho**; só vira contrato com aceite explícito.
4. Decisão mudada depois volta ao registro com o motivo — inventário muda save e balanceamento, histórico é o que permite confiar.
5. Sem resposta, vale a recomendação padrão da pergunta, **registrada como suposição**. A entrevista termina em especificação, não em "acho que é isso".

## Fase 1 — O papel do inventário neste jogo

- "Gerenciar itens é parte da graça ou é burocracia entre as partes boas?" (sobrevivência/escassez pede atrito; ação rápida pede inventário quase invisível)
- "O jogador deve **pensar** no que carrega (limite dói) ou carregar tudo e pensar no que usa?"
- "Quanto tempo por sessão ele passa com o inventário aberto — segundos (troca) ou minutos (planejamento)?"
- Referências com motivo: "de qual jogo você quer **esta sensação** aqui — e de qual quer passar longe?" (registre o que extrair de cada uma para a fase de pesquisa)

## Fase 2 — Modelo e limites

**Pergunta central, com recomendação:** qual é o formato?

| Modelo | Quando é a resposta certa |
|---|---|
| Lista/categorias sem limite duro | Coleta ampla, crafting, jogo de construir — gerenciar é organizar, não caber |
| Slots (N espaços, 1 item/pilha cada) | Clareza e pressão leve; o padrão seguro sem gênero forte |
| Grade espacial (item ocupa células) | O **encaixe é o jogo** (sobrevivência, loot tático) — e o custo de interação é alto, assuma sabendo |
| Peso | Realismo/sobrevivência sem o atrito da grade; pede UI de peso legível o tempo todo |

- Empilha? Até quanto por pilha — e o que **não** empilha nunca (equipado, único, com estado)?
- Encheu: recusa e avisa, larga o excedente no chão ou existe overflow (correio/baú)? (Recomendação padrão: recusar e avisar com o item visível — perder em silêncio é o único comportamento proibido.)
- Existe armazenamento fora do corpo (baú, base, stash compartilhado entre personagens)?

## Fase 3 — Itens e regras

- Quais famílias existem: consumível, equipamento (quais slots do corpo?), material/crafting, chave/quest, munição é item ou recurso separado?
- Item tem estado próprio (durabilidade, carga, encantamento, qualidade sorteada) ou é fungível por id? Isso decide instância × pilha no modelo.
- Raridade existe? O que ela muda (poder, preço, só leitura visual)? Como se lê **sem cor**?
- De onde vem e para onde vai: loot de mundo/inimigo, compra, crafting, drop ao morrer (perde o quê, onde fica o corpo/mochila)?

## Fase 4 — Hotbar

- Precisa de hotbar ou o inventário + atalhos de ação bastam? (Jogo pausado ao abrir inventário pode não precisar; tempo real quase sempre precisa.)
- Quantos slots e por qual entrada principal: teclas numéricas, roda do mouse, ombros (LB/RB) ciclando, radial? O controle é cidadão aqui, não adaptação.
- Hotbar é atalho do inventário (recomendação padrão) ou compartimento separado que se abastece? Separado duplica regras de save e de consumo — só com motivo.
- Usar item da hotbar em tempo real: o mundo segue? Trocar arma no meio do combate é permitido ou tem tempo de troca (animação) como custo?

## Fase 5 — Interação e contexto

- Dispositivo principal (mouse arrasta; controle foca e confirma; toque toca) — e os outros dois funcionam **de verdade**, como?
- Abrir o inventário pausa o mundo? Em rede, pausar nem existe: o que protege o jogador com o inventário aberto?
- Ordenar/filtrar/buscar: automático por categoria, botão de ordenar, busca por nome — quanto o tamanho esperado do inventário pede?
- Erros que o jogador comete aqui (vender o item errado, largar o único): quais têm desfazer/confirmação?

## Encerramento

A entrevista fecha preenchendo a especificação: modelo e limite, famílias e regras de item, hotbar e entradas, comportamento de cheio, save e rede — cada linha com a decisão ou a suposição registrada e a referência que a sustenta.

---
_Entrevista criada em 2026-10-17 no padrão da entrevista de concepção do pacote. Pergunta boa de inventário é a que muda save, balanceamento ou a mão do jogador — o resto é implementação._
