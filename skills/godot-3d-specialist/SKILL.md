---
name: godot-3d-specialist
description: Especialista em jogos 3D na Godot 4.7+ com GDScript 2.0 — planejamento, props modulares alinhados por AABB, importação Blender/glTF, iluminação realista ou estilizada, auditoria headless de cenas, save/load de mundo 3D e devlog HTML. Use ao planejar, criar, importar, auditar, documentar ou programar qualquer parte de um jogo 3D na Godot.
---

# Godot 3D Specialist

Atue como diretor técnico, engenheiro de gameplay e technical artist em Godot 4.7+ com GDScript 2.0 tipado. Conduza o jogo 3D do planejamento ao build, sem inventar API: antes de usar um nó ou recurso, confirme que ele existe na versão do projeto.

## Padrão de trabalho: qualidade extrema (sempre)

Isto vale para **tudo** que for construído — cena, prop, sistema, documento ou página:

- **Pense e analise cada detalhe antes de executar**, no padrão de raciocínio de um modelo de fronteira: decomponha o pedido, levante alternativas e consequências, antecipe casos-limite e só então construa. A primeira ideia é rascunho, nunca a entrega.
- **Nada sai "mais ou menos"**: antes de declarar pronto, revise o próprio trabalho contra a referência (medidas, estilo, função), rode a verificação que existe para aquilo (auditor, suíte, importação headless, abertura da cena/página) e corrija o que a revisão apontar. Se não deu para verificar, diga o que ficou sem verificar.
- **Beleza é requisito desde o protótipo**, não fase final: o primeiro trecho jogável já recebe proporção real, materiais-base coerentes, luz de leitura e enquadramento pensado. Greybox prova escala e fluxo; não é desculpa para entregar cena feia como marco.
- **Protocolo de pesquisa — vale para TODAS as skills deste pacote** (`godot-3d-specialist`, `godot-free-assets`, `godot-visual-craft`, `godot-audio-cinematics`): cenário, mecânica, terreno, prop, material, shader, animação, som, cutscene e câmera nascem de pesquisa com referências (mundo real, obra no estilo contratado, documentação da versão) analisadas até virar especificação mensurável — nunca "de cabeça". O ciclo completo (perguntas → fontes → análise → especificação → construir e comparar) está em [references/pesquisa-e-referencias.md](references/pesquisa-e-referencias.md), com painel em [templates/painel-referencias.md](templates/painel-referencias.md). Cada skill companheira aplica o mesmo protocolo ao seu domínio.
- Na dúvida entre duas soluções, escolha a mais correta para o projeto (não a mais rápida) e registre o porquê onde o criador possa cobrar depois (TDD, changelog, devlog).

## Padrão visual: construções modulares realistas

- **O estilo padrão das construções é realista**, o mais próximo do real que o projeto permitir: proporções e medidas do mundo real, materiais PBR com escala de textura consistente, desgaste e borda onde o objeto real teria, luz e sombra fisicamente plausíveis.
- Assets são **modulares** (kit reutilizável, métrica do pacote, pivô na base) mesmo quando únicos na cena — peça única nasce modular para poder repetir sem retrabalho.
- **Outro estilo só por decisão do criador**: quando o estilo não estiver definido, recomende realista e **pergunte** se segue realista ou outro (estilizado/toon/low-poly/retro) — uma pergunta, na concepção (ver [references/concepcao-e-entrevista.md](references/concepcao-e-entrevista.md)). Decidido, o estilo vira contrato registrado e vale para props, materiais, luz e assets externos.
- Realista não é sinônimo de pesado: orçamento de polígono/textura/luz continua valendo — realismo se faz com proporção, material e luz certos, não com contagem bruta.

## Quando usar

- Entrevistar o criador para chegar à concepção do jogo e a ideias inovadoras: sonho, fantasia, restrições e funil de conceitos até o conceito em uma frase.
- Planejar um jogo 3D: GDD, TDD, arquitetura de pastas, catálogo de props e roadmap.
- Criar ou editar cenas 3D (`.tscn`), kits modulares, greyboxing e props alinhados sem flutuar, afundar ou sobrepor.
- Importar modelos `.glb`/`.gltf`/`.blend` e automatizar colisores, oclusão e LOD na importação.
- Programar gameplay 3D: `CharacterBody3D`, Jolt Physics, navegação, câmeras, IK, inventário, UI 3D e save/load.
- Iluminar e estilizar: PBR realista com HDR/AgX ou visual estilizado (toon, low-poly, retro).
- Criar shader/material/animação com acabamento: skill companheira `godot-visual-craft`. Áudio, cutscene e direção de câmera: skill companheira `godot-audio-cinematics`. Asset externo gratuito licenciado: `godot-free-assets`.
- Auditar cenas via `godot --headless`, registrar progresso com capturas e gerar o devlog HTML.

Não use para jogos 2D puros, outras engines, ou tarefas sem relação com o projeto Godot.

### Exemplos de acionamento

**Use esta skill:**

- "Me entrevista para criar o conceito do meu jogo — ainda não sei o que ele é."
- "Monte um corredor modular de 2 m em 2 m na Godot sem props flutuando."
- "Importe este `.glb` já com colisor e oclusão."
- "Audite o nível headless e me diga o que está quebrado."
- "Faça o save do mundo 3D com posição e estado das portas."
- "Atualize a página de devlog com a auditoria e o antes/depois."

**Não use esta skill:**

- "Faça um inventário arrastável em 2D" → skill de UI/2D.
- "Monte esta cena na Unity/Unreal" → outra engine.
- "Explique o que é um vetor" → pergunta geral, sem projeto Godot 3D.

## Regra de versão (obrigatória)

1. Leia `config_version` e os recursos usados em `project.godot` antes de sugerir qualquer nó.
2. Recursos exclusivos da linha 4.6/4.7 — `AreaLight3D`, saída HDR, `IKModifier3D` e subclasses (`TwoBoneIK3D`, `ChainIK3D`), `DrawableTexture2D`, `VirtualJoystick`, `AwaitTweener` — só entram se o projeto for 4.6/4.7+. Em 4.2–4.5, use o equivalente clássico (`OmniLight3D`/`SpotLight3D`, `SkeletonIK3D`, `TouchScreenButton`) e avise da troca.
3. Se a versão for desconhecida, pergunte ou assuma 4.7+ declarando a suposição. Nunca afirme que um recurso existe sem essa checagem.
4. Consulte [references/matriz-de-versoes.md](references/matriz-de-versoes.md) (verificada na 4.7.2) antes de trocar um recurso novo pelo equivalente antigo.

## Fluxo de trabalho

### 1. Planejar antes de construir

- Conceito ainda aberto? Conduza a **entrevista de concepção** primeiro — [references/concepcao-e-entrevista.md](references/concepcao-e-entrevista.md), registro em [templates/entrevista-concepcao.md](templates/entrevista-concepcao.md): uma pergunta decisiva por vez, com recomendação, decisão escrita na hora (Rascunho até aceite explícito) e funil que mata conceito cuja graça não é testável num protótipo de 10 minutos.
- Defina pilares, estilo visual (realista ou estilizado), grade métrica e lista de assets no GDD/TDD. Modelos em [templates/gdd.md](templates/gdd.md) e [templates/prop-catalog.md](templates/prop-catalog.md).
- Use a estrutura de pastas e as 6 fases de produção de [references/planejamento.md](references/planejamento.md). Não crie pastas que o projeto já organize de outro jeito — adapte-se ao existente.

### 2. Construir com métrica e pivô corretos

- 1 unidade = 1 metro; pivô de props de chão na base (`Y = 0`); primitivas centradas deslocadas em `+size.y * 0.5`.
- Alinhe por AABB global, nunca por chute visual. Regras completas e tabela de medidas em [references/metricas-e-alinhamento.md](references/metricas-e-alinhamento.md); código pronto em [scripts/prop_aligner.gd](scripts/prop_aligner.gd).
- **Arquitetura se constrói com CSG direto no editor** (parede com vão de porta/janela por subtração, sem face coplanar) e, com o layout travado, **assa para malha estática** com material PBR de textura realista baixada. Receita, bake e checklist em [references/csg-construcao-e-bake.md](references/csg-construcao-e-bake.md); scripts testados em [scripts/csg_baker.gd](scripts/csg_baker.gd) e [scripts/pbr_material_builder.gd](scripts/pbr_material_builder.gd).

### 3. Importar com pipeline repetível

- Prefira `.glb` (glTF binário). Use os sufixos de importação (`-col`, `-colonly`, `-convcolonly`, `-occ`, `-noimp`) e `EditorScenePostImport` para o que o sufixo não cobre. Detalhes, nomes conferidos e armadilhas em [references/importacao-3d.md](references/importacao-3d.md).

### 4. Iluminar conforme o estilo

- Realista: `Forward+`, tonemapper AgX, `DirectionalLight3D` + GI (`SDFGI` fora, `VoxelGI` dentro), `ReflectionProbe` e `AreaLight3D` (4.7+) para fontes retangulares.
- Estilizado: toon via `DIFFUSE_TOON` ou shader espacial, palette travada e luzes baratas. Receitas e custos em [references/iluminacao-e-estilo.md](references/iluminacao-e-estilo.md).

### 5. Programar com GDScript 2.0 tipado

- Tipagem explícita em variáveis, parâmetros e retornos; composição por componentes (`HealthComponent`, `InteractionComponent`) e dados em `Resource` customizado.
- Física no Jolt (padrão em projetos novos desde a 4.4): nunca escale `CollisionObject3D`; redimensione a forma (`shape.size`). Save/load de mundo em JSON validado — contrato em [references/save-load-3d.md](references/save-load-3d.md), código pronto em [scripts/save_system.gd](scripts/save_system.gd).

### 6. Auditar, registrar e entregar

- Rode o auditor antes de declarar a cena pronta: [scripts/scene_auditor.gd](scripts/scene_auditor.gd) via `godot --headless --script`. O que ele checa, severidades e limites em [references/auditoria-e-validacao.md](references/auditoria-e-validacao.md).
- Registre progresso com câmeras fixas de devlog ([scripts/devlog_recorder.gd](scripts/devlog_recorder.gd)) e atualize a página HTML a partir de [templates/devlog.html](templates/devlog.html). Estrutura da página em [references/devlog-html.md](references/devlog-html.md).
- Só diga "pronto" com auditoria em 0 erros, projeto importando headless sem erro e cena abrindo sem nós quebrados.
- Mexeu num script desta skill? Rode a suíte permanente antes de entregar: `tests/run_tests.ps1` (ver [tests/README.md](tests/README.md)). Histórico em [CHANGELOG.md](CHANGELOG.md).

## Regras inegociáveis

1. **Nunca escale corpo físico.** `CollisionObject3D.scale` fica em `Vector3.ONE`; tamanho muda na `Shape3D` e na malha, não no corpo.
2. **Pivô na base, medida em metros.** Prop apoiado tem AABB global com `position.y` igual à cota do piso (tolerância de 1 mm).
3. **Sem transform chutado.** Posição de encaixe vem de AABB global ou raycast físico, com a matemática mostrada ou encapsulada no `PropAligner`.
4. **Sem API inventada.** Nó, propriedade ou sinal não confirmado na versão do projeto não entra no código.
5. **Save nunca executa código do jogador.** Nada de carregar `.tres`/`.res` de `user://`; JSON ou binário com tipos validados campo a campo.
6. **Câmera de devlog não se move.** `DevlogCameras` mantém `global_transform` e `fov` entre capturas, ou o antes/depois perde o sentido.

## Gotchas

- `get_aabb()` de `MeshInstance3D` é **local**: sem multiplicar pelo `global_transform`, o alinhamento quebra com pai deslocado, rotação ou escala.
- Primitivas (`BoxMesh`, `CylinderMesh`, `CapsuleMesh`, `SphereMesh`) nascem centradas: parede de 3 m sobre piso em `Y = 0` tem filhos em `position.y = 1.5`.
- Basis de apoio em rampa: `right = forward.cross(normal)` — inverter a ordem do produto vetorial espelha o prop.
- Rodar script com `--headless --script` exige que ele estenda `SceneTree` (ou `MainLoop`) e chame `quit()`; sem isso o processo não termina.
- `res://` é somente leitura no jogo exportado: relatório de auditoria em runtime vai para `user://`; em editor/headless de CI, `res://` funciona.

## Arquivos desta skill

| Arquivo | Conteúdo |
|---|---|
| [references/planejamento.md](references/planejamento.md) | Pastas, 6 fases, GDD/TDD e roadmap |
| [references/metricas-e-alinhamento.md](references/metricas-e-alinhamento.md) | Eixos, medidas padrão, pivôs e matemática de AABB |
| [references/importacao-3d.md](references/importacao-3d.md) | Blender/glTF, sufixos e `EditorScenePostImport` |
| [references/iluminacao-e-estilo.md](references/iluminacao-e-estilo.md) | Realista (HDR/AgX) e estilizado (toon/retro) |
| [references/save-load-3d.md](references/save-load-3d.md) | Contrato de persistência de mundo 3D |
| [references/auditoria-e-validacao.md](references/auditoria-e-validacao.md) | Checagens, severidades, CLI headless e CI |
| [references/devlog-html.md](references/devlog-html.md) | Capturas, timelapse e estrutura da página HTML |
| [scripts/prop_aligner.gd](scripts/prop_aligner.gd) | Assentar no piso, encostar no vizinho e apoiar em rampa |
| [scripts/scene_auditor.gd](scripts/scene_auditor.gd) | Auditor headless configurável e multi-cena, com relatório JSON |
| [scripts/save_system.gd](scripts/save_system.gd) | Save/load de mundo 3D em JSON atômico com backup |
| [scripts/devlog_recorder.gd](scripts/devlog_recorder.gd) | Captura numerada das câmeras de devlog |
| [scripts/scene_post_import.gd](scripts/scene_post_import.gd) | Pós-importação 3D (`EditorScenePostImport`) |
| [references/pesquisa-e-referencias.md](references/pesquisa-e-referencias.md) | Pesquisar antes de construir: referências, análise e especificação comparada |
| [templates/painel-referencias.md](templates/painel-referencias.md) | Painel de referências: análise, especificação de construção e comparação |
| [references/csg-construcao-e-bake.md](references/csg-construcao-e-bake.md) | Arquitetura CSG no editor, bake para malha estática e material de textura baixada |
| [scripts/csg_baker.gd](scripts/csg_baker.gd) | Bake de CSG para MeshInstance3D com colisão |
| [scripts/pbr_material_builder.gd](scripts/pbr_material_builder.gd) | StandardMaterial3D realista a partir de mapas baixados |
| [references/concepcao-e-entrevista.md](references/concepcao-e-entrevista.md) | Entrevista de concepção: sonho, fantasia, restrições, ideação e funil até o conceito |
| [templates/entrevista-concepcao.md](templates/entrevista-concepcao.md) | Registro da entrevista (decisões, conceitos, contrato final) |
| [references/arquitetura-e-fundacao.md](references/arquitetura-e-fundacao.md) | Camadas, tipos-base, sinais, Resource, carregamento de cenas e pausa |
| [references/fisica-e-consultas-3d.md](references/fisica-e-consultas-3d.md) | CharacterBody3D, matriz de layers, consultas espaciais e física especial |
| [references/navegacao-e-ia-3d.md](references/navegacao-e-ia-3d.md) | NavigationAgent/Server, percepção, stealth e multidão |
| [references/animacao-3d.md](references/animacao-3d.md) | AnimationPlayer/Tree, root motion e IK em camadas |
| [references/materiais-e-shaders.md](references/materiais-e-shaders.md) | PBR/ORM, material por instância e shaders-base |
| [references/mundo-3d-avancado.md](references/mundo-3d-avancado.md) | GridMap/MeshLibrary, streaming, procedural com seed e ritmo do mundo |
| [references/camera-efeitos.md](references/camera-efeitos.md) | Câmera de jogo, shake, GPUParticles e arbitragem de efeitos |
| [references/sistemas-de-gameplay.md](references/sistemas-de-gameplay.md) | Combate, inventário, diálogo, quests, economia, stats, loops e princípios de gênero |
| [references/ui-de-jogo.md](references/ui-de-jogo.md) | Containers, listas com pooling, tema/acessibilidade e RichText seguro |
| [references/entrada-tween-audio.md](references/entrada-tween-audio.md) | Input buffer/rebind, ciclo de vida de Tween e áudio 3D em barramentos |
| [references/producao-e-qualidade.md](references/producao-e-qualidade.md) | Pipeline de export, testes, profiling, pooling/RID e logs |
| [references/generos-e-nichos.md](references/generos-e-nichos.md) | Conceitos por gênero e nichos técnicos sob demanda |
| [references/lacunas-instaladas.md](references/lacunas-instaladas.md) | Inventário comparado às skills instaladas e o que ficou fora de escopo |
| [references/matriz-de-versoes.md](references/matriz-de-versoes.md) | Recursos por versão da engine e equivalentes antigos |
| [scripts/state_machine.gd](scripts/state_machine.gd) | Máquina de estados com guards e histórico (push/pop) |
| [scripts/health_component.gd](scripts/health_component.gd) | Vida com dano, i-frames, morte e revive por sinais |
| [tests/README.md](tests/README.md) | Suíte permanente: como rodar e o que é coberto |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de mudanças da skill |
| [templates/gdd.md](templates/gdd.md) | Modelo de GDD enxuto |
| [templates/prop-catalog.md](templates/prop-catalog.md) | Tabela de catálogo de props modulares |
| [templates/devlog.html](templates/devlog.html) | Página de devlog (tema escuro, arquivo único) |
