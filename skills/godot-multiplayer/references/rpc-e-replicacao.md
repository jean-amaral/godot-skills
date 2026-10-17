# RPC e replicação (Godot 4.7, documentação oficial)

Fontes: [High-level multiplayer](https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html), `MultiplayerSynchronizer`, `MultiplayerSpawner`, `SceneReplicationConfig` (docs da engine, estáveis).

## @rpc — eventos entre peers

Declaração: `@rpc(modo_de_autoridade, modo_de_chamada, modo_de_transferencia, canal)`. Padrão: `@rpc` = `("authority", "call_remote", "reliable", 0)`.

| Argumento | Valores | Significado |
|---|---|---|
| Autoridade | `"authority"` / `"any_peer"` | Quem pode chamar: só a autoridade do nó, ou qualquer peer |
| Chamada local | `"call_remote"` / `"call_local"` | Se também executa em quem chamou |
| Transferência | `"reliable"` / `"unreliable"` / `"unreliable_ordered"` | Confiável (chega, ordenado) × rápido (pode cair) |
| Canal | int (0 padrão) | Canais separam fluxos (ex.: chat não disputa com gameplay) |

Chamada: `minha_funcao.rpc()` (todos os peers) e `minha_funcao.rpc_id(id)` (um peer). O remetente de um RPC se pergunta com `multiplayer.get_remote_sender_id()`.

Contrato rígido (da documentação):

- A função `@rpc` tem que existir **com a mesma assinatura e no mesmo caminho de nó** em todos os peers que a recebem — o conjunto de RPCs do script é validado junto; RPC não usado também entra na conta.
- `"unreliable"` é para o que se repete sozinho (posição digitada toda hora, mira): perder um pacote não importa porque o próximo conserta. Evento que não pode cair (dano, compra, morte) é `"reliable"` — ou estado sincronizado, não evento.

## MultiplayerSpawner — nascer e morrer para todos

- Configure as cenas spawnáveis no editor ou com `add_spawnable_scene(path)`; o nó replicado nasce sob o `spawn_path` nos outros peers, com sinais `spawned`/`despawned` nos remotos.
- `spawn(data)` faz spawn customizado via `spawn_function` (o Callable executa em todos os peers com o mesmo `data`): use para nascimento que precisa de parâmetros (classe, cor, loadout) — `data` é o contrato, valide-o.
- `spawn_limit` limita instâncias simultâneas do spawner; 0 = sem limite (limite é design anti-abuso também).
- Quem spawna é a autoridade do spawner — na prática, o servidor spawna jogadores/inimigos/mundo; cliente não spawna o que importa sem pedir ao servidor.

## MultiplayerSynchronizer — estado contínuo

- Filho do nó a sincronizar (ou `root_path` apontando o alvo); sincroniza as propriedades do `replication_config` (`SceneReplicationConfig`) **da autoridade para os demais**.
- Cada propriedade no config: `add_property(path)`, modo de replicação (`REPLICATION_MODE_ALWAYS` / `ON_CHANGE` / `NEVER`), flags `spawn` (valor inicial vai no spawn), `sync` e `watch`.
  - Contínuo que muda sempre (posição): Always com `replication_interval` sob controle (ex.: 0.05–0.1 s conforme o jogo) — intervalo 0 = todo frame, e a banda descobre rápido.
  - Muda raro (vida, munição): On Change. Estático pós-nascimento: só `spawn`.
- `delta_interval` acumula e envia diferenças conforme o modo; visibilidade por peer: `public_visibility`, `set_visibility_for(peer, bool)`, filtros (`add_visibility_filter` + `update_visibility`) — o que um peer não precisa ver, ele não recebe (banda e anti-wallhack andam juntos).
- **Não sincroniza** propriedade do tipo `Object`/`Resource` nem ids de instância/RID: sincronize **dados** (valores, caminhos, índices), nunca o objeto.
- Propriedades típicas: `position`/`rotation`, velocidade quando o remoto interpola, estado de animação **como dado** (nome/índice + tempo), nunca o nó de animação inteiro.

## Autoridade em cena (o esqueleto de tudo)

- `set_multiplayer_authority(peer_id)` normalmente no spawn, pelo servidor. `is_multiplayer_authority()` decide, em cada máquina, "eu simulo ou eu apresento?".
- Nó replicado sem autoridade definida tem autoridade = servidor (1): ótimo para mundo/inimigos; errado para o avatar do jogador (a autoridade dele é ele).
- Entrada do jogador: o dono lê input e ou simula com autoridade (co-op confiável) ou envia intenção por RPC `any_peer` para o servidor simular (competitivo) — a skill de dimensão decide o desenho fino.

---
_Referência criada em 2026-10-17 a partir da documentação oficial da Godot 4.7. Enum/nome exato de constante: confira a classe na versão do projeto antes de codar._
