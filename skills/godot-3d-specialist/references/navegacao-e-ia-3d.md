# Navegação e IA 3D

## Navegação sem travar

- `NavigationRegion3D` com `NavigationMesh` por área coerente (interior/exterior separados); bake no editor para nível estático, e rebake só do que mudou.
- `NavigationAgent3D` no agente: alvo por `target_position`, direção por `get_next_path_position()`, chegada por `is_navigation_finished()` / distância ao alvo. Não leia o caminho interno para "otimizar" — o agente já evita obstáculo dinâmico básico.
- **Retarget com parcimônia**: atualizar o alvo a cada frame para perseguir jogador gera recálculo constante. Atualize por intervalo (0,1–0,25 s) ou por deslocamento mínimo do alvo.
- Custos e links: área cara (água, lama) com custo maior na região/link; `NavigationLink3D` para pulo/teleporte/porta de um sentido — link não é caminho andando.
- Layers de navegação separam quem passa onde (voador × terrestre); agente na layer errada "não acha caminho" sem erro visível.

## Node ou servidor (RID)?

| Caso | Escolha |
|---|---|
| Dezenas de agentes, comportamento próprio | `NavigationAgent3D` (nó) |
| Centenas/milhares de consultas simples, enxame | `NavigationServer3D` direto (RID), sem nó por agente |
| Pathfinding pontual (clique, preview) | `NavigationServer3D.map_get_path()` |

Comece pelo nó; desça ao servidor quando o Profiler mostrar custo de agentes, não por estética.

## IA por estados (patrulha → suspeita → perseguição)

- Estados explícitos com transição por percepção, não por distância crua: ver (cone + linha de visão por raycast físico), ouvir (raio com atenuação por parede) e esquecer (temporizador de memória).
- Percepção barata em duas fases: distância primeiro (barato), raycast só para quem passou — raycast para todos a cada frame é o custo escondido clássico.
- Stealth/horror usam a mesma base: exposição do jogador combina visibilidade (luz/sombra aproximada por raycast e nível de luz), ruído emitido e último rastro conhecido; o "diretor" de horror dosa pressão por cooldown de sustos, não por spawn aleatório.
- Debug visual ligado no editor (`NavigationAgent3D` debug) antes de culpar o bake: maioria dos "IA burra" é alvo inalcançável ou layer errada.
- Estado da IA mora em máquina de estados testável — ver [../scripts/state_machine.gd](../scripts/state_machine.gd).

## Multidão

Multidão não é "mais agentes": acima de dezenas, simplifique para steering local (separação/alinhamento) + caminho grosso compartilhado por grupo, e detalhe de navegação só nos agentes próximos ao jogador.

---
_Referência revisada em 2026-10-16 (Godot 4.7.2). A suíte `tests/` prova os scripts do pacote; as receitas daqui são orientação de uso, não comportamento testado. Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
