# Lacunas em relação às skills Godot instaladas

Inventário de 2026-10-16: corpos das skills `godot-*` instaladas lidos e
comparados ao baseline deste pacote (3D, 4.7.2, scripts testados).
Status: **adicionado na 2.1.0** — os itens de alta, média e baixa relevância
abaixo entraram como referências originais deste pacote (e scripts testados
onde havia código reutilizável: `StateMachine`, `HealthComponent` e o
`SaveSystem` endurecido). A seção "fora de escopo" continua fora, por decisão
registrada. Procedência indicada para rastreabilidade, sem cópia de texto
das skills de origem.

## Alta relevância para um especialista 3D

- Arquitetura: camadas, matriz Object/RefCounted/Resource/Node, composition root/DI tipada, boot order sem "God Autoload" (godot-master, godot-composition, godot-autoload-architecture).
- Validação de código do projeto: naming, signal-up/call-down, coleções tipadas, safe casting, warnings como erro (godot-gdscript-mastery, godot-signal-architecture, godot-auditor).
- Resource seguro: `duplicate`/local_to_scene, serialização aninhada, cache de recursos (godot-resource-data-patterns).
- Carregamento de cenas: loader threaded assíncrono, transição sem travar, respawn sem `change_scene` (godot-scene-management).
- Máquina de estados hierárquica com guards e history (godot-state-machine-advanced).
- Iluminação: roteador SDFGI/VoxelGI/LightmapGI, cascatas e bias de sombra (godot-3d-lighting).
- Materiais PBR: packing ORM, checklist `StandardMaterial3D`, materiais por instância (godot-3d-materials).
- Mundo 3D: GridMap/MeshLibrary com colisão/oclusão/LOD e streaming (godot-3d-world-building).
- Câmera 3D (SpringArm/oclusão), partículas GPUParticles e shaders-base/post (godot-camera-systems, godot-particles, godot-shaders-basics).
- Animação: AnimationPlayer/AnimationTree, root motion, blend em camadas (godot-animation-player, godot-animation-tree-mastery).
- Física e consultas: CharacterBody3D escadas/slopes, matriz de layers, ray/shape/point e picking (godot-physics-3d, godot-raycasting-queries).
- Navegação e IA: NavigationAgent/Region, bake assíncrono, custos/links, FSM chase/patrol (godot-navigation-pathfinding, godot-ai-navigation).
- Combate 3D: dano/saúde/i-frames, Hitbox/Hurtbox `Area3D`, armas hitscan/projétil (godot-combat-system + gêneros shooter/action-RPG).
- Sistemas data-driven: inventário, diálogo, quests, economia, stats e habilidades com persistência por ids (godot-inventory-system, godot-dialogue-system, godot-quest-system, godot-economy-system, godot-rpg-stats, godot-ability-system).
- Save endurecido: migração de versão, integridade SHA-256 e fallback ao `.bak` (godot-save-load-systems) — o nosso cobre atomicidade e validação, não migração/integridade.
- Entrada/tween/áudio: input buffer, rebind, deadzone, barramentos e pool de vozes 3D (godot-input-handling, godot-tweening, godot-audio-systems).
- Percepção stealth/horror: cone de visão/LoS, audição com oclusão, exposição à luz (godot-genre-stealth, godot-genre-horror).
- UI de jogo: containers responsivos, listas com pooling, Theme e acessibilidade em runtime (godot-ui-containers, godot-ui-theming).
- Produção: CI/export headless, profiling, pooling/culling/MultiMesh, auditoria de código (godot-export-builds, godot-testing-patterns, godot-performance-optimization, godot-builder).

## Média relevância

- Servidores RID (Physics/RenderingServer), budgets e pré-aquecimento de shader (godot-server-architecture, godot-performance-optimization).
- Fundação complementar: configuração de runtime, pooling genérico, pause por `process_mode`, PCK/feature tags (godot-project-foundations, godot-project-templates).
- Ritmo de mundo: ciclo dia/noite e fog, decals/projetores, CSG de greybox, geração procedural com seed (godot-3d-lighting, godot-procedural-generation).
- Física especial: ragdoll, veículos, SoftBody e joints (godot-physics-3d).
- Gameplay secundário: loot, sinks de economia, buffs/árvore de habilidades, loops de ondas/coleta e balanceamento Monte Carlo (clusters de sistemas e game loops).
- Princípios de gênero reutilizáveis: RNG com seed run-vs-meta, validador de soft-lock e economia em centavos inteiros (roguelike/metroidvania/simulation).
- RichText/BBCode com sanitização, escala de UI e foco (godot-ui-rich-text, godot-ui-theming).
- Entrega complementar: assinatura/notarização, gates golden/fuzz, logger estruturado e QA visual (godot-export-builds, godot-debugging-profiling, godot-agent-vision).

## Baixa relevância (nicho)

- Scaffolds prontos de gênero, composição de apps/editor, lipsync/TTS, ghost de time-trial e segredos (project-templates, composition-apps, dialogue, game-loop-time-trial, mechanic-secrets).
- Bake 3D→sprites, wrappers Steam/Discord, web (Compatibility/IndexedDB) e criptografia de slots.
- Frame-data de fighting e narrativa visual-novel/party como conceito.

## Fora de escopo (decisão registrada: não adicionar)

- Multiplayer: autoridade, RPC, replicação, lobby e anti-trapaça proporcional ganharam skills próprias no pacote em 2026-10-17 (`godot-multiplayer` + `godot-multiplayer-3d`/`godot-multiplayer-2d`), a partir da documentação oficial. Servidor dedicado avançado (prediction/rollback, matchmaking em escala) continua fora.
- 2D puro e turnos: fora do escopo **desta skill 3D** — o 2D ganhou casa própria no pacote em 2026-10-17 (`godot-2d-specialist` + `godot-2d-visual-craft`). Turnos/card game/rhythm continuam fora do pacote.
- Plataformas não-alvo: console sob NDA, mobile nativo/IAP e VR/OpenXR (godot-platform-console, godot-platform-mobile, godot-platform-vr).
