# Lobby e sessão

A sessão é uma máquina de estados (sem lobby → lobby → jogando → fim → lobby), com um dono (servidor) e todos os peers vendo a mesma verdade.

## Subir e conectar (oficial)

- Host: `ENetMultiplayerPeer.new()`, `create_server(porta, max_clientes)`, atribuir a `multiplayer.multiplayer_peer`. Cliente: `create_client(endereco, porta)` idem. (Web: `WebSocketMultiplayerPeer`/`WebRTCMultiplayerPeer` — o ENet não roda em HTML5.)
- Trate os sinais do `MultiplayerAPI` de cena: `peer_connected(id)`, `peer_disconnected(id)`, `connected_to_server`, `connection_failed`, `server_disconnected`. Cada um muda a sessão: entrou → registrar; saiu → limpar; host caiu → encerrar com dignidade (mensagem + volta ao menu), nunca tela congelada.
- Erros de `create_*` retornam `Error`: trate e mostre (porta ocupada, endereço inalcançável), não tente de novo em loop silencioso.

## Registro de jogadores (a tabela da sessão)

O servidor mantém o registro (id → nome, time, pronto, personagem) e o distribui (RPC confiável ou estado sincronizado do lobby). Regras:

- **Nome do jogador vem do jogador, identidade vem do peer**: exiba o nome que ele mandou (sanitizado, com tamanho máximo), mas a chave é sempre o id que a engine deu — nome repetido não quebra nada.
- Registrar ao conectar **e** ao entrar no lobby são momentos diferentes: peer conectado sem registro é "conectando", não jogador.
- Saída no meio: o servidor remove do registro, despawna o avatar (o `MultiplayerSpawner` cuida nos remotos) e decide o destino do que era dele (loot, vaga, bot assume?) — decisão de design, registrada, não acidente.

## Entrada tardia (join in progress)

- Quem entra no meio recebe: spawns existentes (o Spawner replica o que está sob ele) + estado inicial via propriedades `spawn` do Synchronizer + o que for evento passado (placar, tempo) via RPC de boas-vindas do servidor. Se o seu jogo não suporta entrada tardia, **diga e bloqueie** no lobby — fingir que suporta é pior.
- Cena de jogo e cena de lobby separadas, com a troca comandada pelo servidor (`rpc` de "carregar partida" `call_local` para todos trocarem juntos, cada um confirmando "carregado" antes do início).

## Fim e reconexão

- Fim de partida: servidor declara (RPC confiável), todos voltam ao lobby ou ao menu **juntos**, com o estado da sessão limpo de forma idempotente (voltar duas vezes não quebra).
- Reconexão de verdade (voltar sendo "o mesmo jogador") é recurso próprio: token de sessão + servidor guardando a vaga por um tempo. Sem isso, quem caiu é um jogador novo — declare, não prometa.
- Desligar: ao fechar, feche o peer (`multiplayer.multiplayer_peer.close()` / atribuir novo peer) e trate o `server_disconnected` nos clientes restantes — processo zumbi segurando porta é o bug clássico de "não consigo hospedar de novo".

## Single-player pelo mesmo caminho

- Antes de qualquer peer de rede, o padrão seguro é `multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()` ou simplesmente nunca trocar o peer: `multiplayer.get_peers()` vazio e a autoridade é local. Desenhe lobby/sessão para colapsar nesse caso (host de 1) e o modo solo não vira um segundo jogo para manter.

---
_Orientação criada em 2026-10-17 a partir da documentação oficial de multiplayer da Godot 4.7 (sinais e peers). Nomes de sinais: confira `MultiplayerAPI` na versão do projeto._
