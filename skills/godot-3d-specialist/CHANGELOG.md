# Changelog — godot-3d-specialist

Formato: data, versão da skill, engine usada na verificação.

## 2.2.4 — 2026-10-16 (verificado na Godot 4.7.2)

- **Construção CSG → bake** ([references/csg-construcao-e-bake.md](references/csg-construcao-e-bake.md)): arquitetura direto no editor (parede/porta/janela por subtração sem face coplanar), bake para malha estática com checklist de normais/AABB/colisão/fonte preservada, e material PBR de textura realista baixada (triplanar para parede assada).
- **Pesquisa antes de construir** ([references/pesquisa-e-referencias.md](references/pesquisa-e-referencias.md) + [templates/painel-referencias.md](templates/painel-referencias.md)): regra do pacote para cenário, mecânica, terreno e prop — perguntas, fontes certas por pergunta, análise que vira especificação mensurável e comparação final na mesma câmera da referência.
- Scripts novos testados na suíte: `CsgBaker` (parede CSG com vão assada, AABB e colisão conferidos) e `PbrMaterialBuilder` (material salvo em `.tres` e recarregado).

## 2.2.3 — 2026-10-16

- **Padrão de trabalho — qualidade extrema** no SKILL.md: analisar cada detalhe (alternativas, consequências, casos-limite) antes de construir, revisar o próprio trabalho com a verificação que existe para aquilo, e beleza como requisito desde o protótipo, não como fase final.
- **Padrão visual — construção modular realista**: estilo padrão do pacote (proporções/materiais reais, modular sempre); outro estilo só por decisão do criador, perguntada na entrevista de concepção e registrada como contrato. Refletido em concepção, planejamento, GDD e iluminação.

## 2.2.2 — 2026-10-16

- Ponteiro para a skill companheira `godot-free-assets` (busca/download de assets CC0/CC-BY) em importação: asset que falta se obtém lá, com licença e crédito, antes de importar aqui.

## 2.2.1 — 2026-10-16 (verificado na Godot 4.7.2)

Correções da revisão do pacote, todas com teste onde há código:

- **DevlogRecorder**: coleta câmeras filhas de `DevlogCameras` **e** do grupo `devlog_cameras` (sem duplicar) e avisa quando não há nenhuma — antes, seguir a documentação à risca capturava 0 frames em silêncio.
- **StateMachine**: `push_state` falho não toca mais o histórico; transição reentrante a partir de `enter()` é recusada; `pop_state` retoma com `enter_resume()` quando existe; pilha com teto (`max_history_depth`).
- **SaveSystem**: spawn sem cena atual cai para a raiz com aviso (sem dereferenciar `current_scene` nulo) e a entidade restaurada entra no grupo `persist_3d`.
- **HealthComponent**: antes do `_ready` já responde com vida cheia (inicialização preguiçosa), em vez de parecer morto com 0.
- Template de devlog sem imagens quebradas (placeholders até existirem capturas), rodapés distinguindo script testado de orientação revisada, pasta vazia fora do zip e pacote distribuído com nome versionado.

## 2.2.0 — 2026-10-16 (verificado na Godot 4.7.2)

- Novo módulo de **entrevista de concepção** ([references/concepcao-e-entrevista.md](references/concepcao-e-entrevista.md) + [templates/entrevista-concepcao.md](templates/entrevista-concepcao.md)): uma pergunta decisiva por vez com recomendação, decisão registrada na hora como Rascunho (Final só com aceite), fases sonho→fantasia→restrições→ideação→funil→contrato, e hipótese de inovação falsificável alimentando o GDD. Lacuna apontada na comparação com as skills instaladas, que só têm entrevista genérica de decisões.

## 2.1.0 — 2026-10-16 (verificado na Godot 4.7.2)

- Inventário comparado às skills Godot instaladas ([references/lacunas-instaladas.md](references/lacunas-instaladas.md)): lacunas de alta, média e baixa relevância adicionadas de forma original; multiplayer, 2D puro e plataformas não-alvo registrados como fora de escopo.
- Novas referências: arquitetura/fundação, física e consultas, navegação/IA, animação, materiais/shaders, mundo avançado, câmera/efeitos, sistemas de gameplay, UI de jogo, entrada/tween/áudio, produção/qualidade e gêneros/nichos.
- Novos scripts testados na suíte: `StateMachine` (guards, push/pop) e `HealthComponent` (dano, i-frames, morte, revive).
- `SaveSystem` endurecido: SHA-256 de integridade, fallback automático ao `.bak` e gancho `migrate_save()` — com teste de principal adulterado caindo ao backup.

## 2.0.0 — 2026-10-16 (verificado na Godot 4.7.2)

- Reestruturação multiarquivo: `SKILL.md` enxuto + `references/`, `scripts/`, `templates/`, `tests/`.
- `PropAligner`: AABB por transform **acumulado dos ancestrais** (não `global_transform`, inválido fora da árvore); ordem do produto vetorial da rampa corrigida.
- `SceneAuditor`: configurável e multi-cena (`--config`, `ignore_types`, `ignore` por prefixo, `max_lights`, `max_texture_size`); novos tipos `MISSING_COLLISION_SHAPE` coberto por teste, `TOO_MANY_LIGHTS`, `TEXTURE_TOO_LARGE`.
- Novos scripts: `SaveSystem` (JSON atômico com backup), `DevlogRecorder`, `ScenePostImport`.
- Suíte permanente em `tests/` (runner único `run_tests.ps1`): PropAligner, SaveSystem, importação de sufixos em `.glb`, auditor em 8 cenas, config do auditor e abertura do devlog HTML.
- Regra de versão obrigatória e matriz em `references/matriz-de-versoes.md` (classes conferidas em runtime na 4.7.2 **e** na 4.5.1).
- Lições da suíte registradas onde são usadas: importação remove o sufixo do nome do nó; inferência a partir de `Variant` é erro em projeto estrito (`SaveSystem` tipado de ponta a ponta); runner com timeout de 120 s por etapa, porque `--script` que falha ao carregar nunca chama `quit()`.
- Removidas alegações não confirmadas da v1 (“CSG Autosmooth”, scaling retro 3D).

## 1.0.0 — versão original

- Arquivo único `SKILL.md` (planejamento, métricas, importação, iluminação, auditoria, save/load, devlog), sem testes executáveis.
