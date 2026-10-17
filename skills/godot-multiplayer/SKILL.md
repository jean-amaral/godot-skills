---
name: godot-multiplayer
description: Multiplayer de alto nível na Godot 4.7+ baseado na documentação oficial — arquitetura cliente/servidor e peer-to-peer, autoridade (multiplayer authority), RPCs, MultiplayerSpawner e MultiplayerSynchronizer, lobby, segurança e testes com múltiplas instâncias. Use ao planejar ou implementar qualquer recurso online/cooperativo/competitivo num projeto Godot, antes das skills específicas de dimensão (godot-multiplayer-2d e godot-multiplayer-3d).
---

# Godot Multiplayer

Multiplayer não é recurso que se adiciona no fim: é **arquitetura** — quem decide, quem confia, o que trafega. A skill-mãe define esse contrato (documentação oficial: [High-level multiplayer](https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html)); a dimensão mora nas companheiras `godot-multiplayer-3d` e `godot-multiplayer-2d`. Sem API inventada: confirme classes na documentação da versão do projeto.

## Pesquisa sempre (regra do pacote)

Antes de criar ou alterar qualquer coisa nesta disciplina, **pesquise informações e referências atuais**: documentação oficial da versão do projeto, referências de imagem/vídeo/texto e como quem é bom resolve o mesmo problema — e transforme a pesquisa em especificação antes de executar. Primeira ideia é rascunho, nunca entrega. Método completo (perguntas, fontes, verificação cruzada e registro): skill `agent-frontier-reasoning`. Sem internet, declare explicitamente o que ficou não verificado e baixe a confiança do afetado.

## A decisão que vem antes de todo código

Escreva e registre (no GDD/TDD) antes de abrir o editor:

1. **Topologia**: servidor dedicado, host-jogador (listen server) ou peer-to-peer? Quem é a autoridade do mundo?
2. **Confiança**: jogadores são confiáveis (co-op entre amigos) ou adversários (competitivo)? Isso decide o quanto o servidor valida.
3. **O que sincroniza**: estado contínuo (posição), eventos (tiro, compra) ou os dois — cada um tem ferramenta própria abaixo.
4. **Sessão**: lobby, entrada no meio da partida, saída/reconexão, fim de partida. Multiplayer sem desenho de sessão quebra na segunda pessoa que entra.

## Modelo mental oficial (Godot 4.7)

- Cada processo é um **peer** com id único; `multiplayer.multiplayer_peer` recebe a implementação (`ENetMultiplayerPeer` padrão; `WebSocketMultiplayerPeer`/`WebRTCMultiplayerPeer` para web/outros casos). Servidor é o peer **1**.
- **Autoridade** é por nó: `set_multiplayer_authority(id)` / `is_multiplayer_authority()`. Quem tem autoridade **decide e replica**; os demais apresentam. Um nó por padrão tem como autoridade o servidor (1).
- **RPC** é evento/chamada entre peers: função anotada `@rpc(...)` chamada via `.rpc()` (todos) ou `.rpc_id(id)`. A mesma declaração precisa existir no mesmo caminho de nó em todos os peers.
- **Replicação de cena** é declaração, não código de rede: `MultiplayerSpawner` replica criação/destruição de nós spawnáveis; `MultiplayerSynchronizer` sincroniza propriedades configuradas da autoridade para os demais.
- **Offline é um peer também**: `OfflineMultiplayerPeer` permite o mesmo código rodar single-player — desenhe para isso e o modo solo sai de graça.

## Fluxo de trabalho

### 1. Conexão e sessão

- Suba host (`create_server`) ou conecte (`create_client`) com tratamento de sinais do `multiplayer` (`peer_connected`, `peer_disconnected`, `connected_to_server`, `connection_failed`, `server_disconnected`) — conexão sem tratar falha é lobby que congela.
- Lobby é estado sincronizado (quem entrou, nome, pronto, time) com dono claro (servidor), não variáveis soltas replicadas "e torcer". Fluxo completo em [references/lobby-e-sessao.md](references/lobby-e-sessao.md).

### 2. Spawn e autoridade

- Jogador entra → servidor instancia a cena do jogador via `MultiplayerSpawner` (registrada com `add_spawnable_scene`), define a autoridade daquele jogador (`set_multiplayer_authority(peer_id)`) e o nome do nó **é o id do peer** (a convenção que torna tudo achável).
- Quem não tem autoridade **desliga a própria simulação cara** (input, física decisiva) e apresenta o resultado — remoto não simula duas vezes.

### 3. Sincronizar: estado × evento

| Necessidade | Ferramenta |
|---|---|
| Posição/estado contínuo | `MultiplayerSynchronizer` + `SceneReplicationConfig` (propriedades com modo Always/On Change, intervalos) |
| Criar/destruir nó para todos | `MultiplayerSpawner` (spawnable scenes ou `spawn()` customizado) |
| Evento pontual (tiro, emote, compra confirmada) | `@rpc` com modo de transferência certo (confiável × não confiável) |
| Entrada do jogador | RPC `any_peer` para a autoridade, validada por ela — nunca posição decidida pelo cliente em jogo não confiável |

Detalhe de RPC/replicação/visibilidade em [references/rpc-e-replicacao.md](references/rpc-e-replicacao.md); orçamento de banda e interpolação em [references/banda-interpolacao-e-seguranca.md](references/banda-interpolacao-e-seguranca.md).

### 4. Testar como multiplayer de verdade

- **Nunca** declare pronto testando sozinho: rode 2+ instâncias (host + cliente[s]) — no editor (múltiplas janelas/instâncias de depuração) ou builds exportados, via `godot-ai-mcp` quando disponível.
- Teste os feios: cliente entra no meio, cliente sai no meio, host cai, dois fazem a mesma ação no mesmo instante, pacote atrasa/perde (latência simulada quando a ferramenta permitir).
- Log por peer (quem logou, id, autoridade) ou depuração de rede vira adivinhação. Checklist em [templates/checklist-multiplayer.md](templates/checklist-multiplayer.md).

## Regras inegociáveis

1. **Cliente não decide o que importa**: dano, economia, posição competitiva e vitória são validados/decididos pela autoridade. Cliente pede; autoridade concede.
2. **Minimizar confiança e tráfego**: sincronize o mínimo (propriedade, intervalo, visibilidade por peer com `set_visibility_for`), valide todo argumento de RPC `any_peer` (alcance, tipo, dono).
3. **`@rpc` igual dos dois lados**: mesma assinatura e mesmo caminho de nó em todos os peers — divergência invalida o conjunto de RPCs do script.
4. **Nome de nó replicado é identidade**: jogador = id do peer; nada de nome livre gerado localmente em cada máquina.
5. **Single-player é o mesmo código** com `OfflineMultiplayerPeer`: se o solo precisa de código paralelo, a arquitetura vazou.

## Arquivos desta skill

| Arquivo | Conteúdo |
|---|---|
| [references/rpc-e-replicacao.md](references/rpc-e-replicacao.md) | @rpc (modos, autoridade, canais), Spawner/Synchronizer e SceneReplicationConfig |
| [references/lobby-e-sessao.md](references/lobby-e-sessao.md) | Host/cliente, sinais de conexão, lobby, entrada/saída e fim de partida |
| [references/banda-interpolacao-e-seguranca.md](references/banda-interpolacao-e-seguranca.md) | Intervalos, visibilidade, interpolação de remotos, validação e anti-trapaça básico |
| [templates/checklist-multiplayer.md](templates/checklist-multiplayer.md) | Checklist de decisão, implementação e testes com múltiplas instâncias |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de mudanças da skill |
