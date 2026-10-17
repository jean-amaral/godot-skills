# Checklist multiplayer — <projeto/recurso>

## Decisões (antes do código)

- [ ] Topologia: <dedicado / host-jogador / P2P> — autoridade do mundo: <...>
- [ ] Confiança: <co-op confiável / competitivo> — o que o servidor valida: <...>
- [ ] Dimensão: skill `godot-multiplayer-2d` / `godot-multiplayer-3d` aplicada
- [ ] Sessão: lobby, entrada tardia <sim/não>, reconexão <sim/não>, fim de partida: <...>
- [ ] Single-player pelo mesmo caminho (peer offline): [ ]

## Implementação

- [ ] Sinais de conexão tratados (entrou, saiu, falhou, host caiu)
- [ ] Spawn pelo `MultiplayerSpawner`; nome do avatar = id do peer; autoridade definida no spawn
- [ ] Estado contínuo no `MultiplayerSynchronizer` (intervalo e modo por propriedade)
- [ ] Eventos em `@rpc` com transferência certa (contínuo ≠ confiável)
- [ ] Remotos não simulam o que não têm autoridade (input/física desligados)
- [ ] Visibilidade por peer onde banda/trapaça pedem
- [ ] Todo RPC `any_peer` validado (dono, tipo, faixa, momento)

## Testes (2+ instâncias de verdade)

- [ ] Host + cliente(s) jogando o fluxo completo
- [ ] Cliente entra no meio / sai no meio / host cai
- [ ] Ação simultânea dos dois lados (mesmo item, mesma porta)
- [ ] Latência/perda simuladas: remoto continua legível, sem teleporte seco
- [ ] Solo (offline) continua funcionando pelo mesmo código
- [ ] Log por peer liga cada erro à máquina certa
