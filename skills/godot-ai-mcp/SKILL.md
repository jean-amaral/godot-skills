---
name: godot-ai-mcp
description: Trabalhar dentro do editor Godot vivo através do MCP Godot AI (hi-godot/godot-ai) — conectar e conferir a sessão, ler hierarquia/propriedades, criar e editar cenas/nós/scripts/UI/materiais/animação/câmera, rodar o jogo e testes, ler logs e screenshots para iterar com evidência. Use quando o Godot AI estiver conectado (ou deva estar) e a tarefa for construir/alterar/depurar algo num projeto Godot pelo MCP, em vez de editar arquivos às cegas.
---

# Godot AI MCP

O MCP transforma o agente de "quem edita texto e torce" em **quem opera o editor e vê o resultado**. A regra que sustenta todas as outras: **nenhuma mudança às cegas** — leia o estado, mude pouco, rode, olhe, corrija.

Instalação do plugin e ligação do cliente: skill `godot-plugins-installer` (v4.3.0, Godot 4.7+, requer `uv`). Catálogo completo e oficial: `docs/TOOLS.md` do repositório `hi-godot/godot-ai` (46 ferramentas, 120+ operações). Esta skill é o **método de trabalho** sobre ele.

## Pesquisa sempre (regra do pacote)

Antes de criar ou alterar qualquer coisa nesta disciplina, **pesquise informações e referências atuais**: documentação oficial da versão do projeto, referências de imagem/vídeo/texto e como quem é bom resolve o mesmo problema — e transforme a pesquisa em especificação antes de executar. Primeira ideia é rascunho, nunca entrega. Método completo (perguntas, fontes, verificação cruzada e registro): skill `agent-frontier-reasoning`. Sem internet, declare explicitamente o que ficou não verificado e baixe a confiança do afetado.

## Como a ligação funciona (para depurar sem chute)

```
Cliente MCP (Antigravity/Claude Code/Codex)
  └─ godot-ai attach (stdio)            ← comando gerado pelo dock; URL crua não autentica
      └─ servidor Python local :8000 (HTTP autenticado)
          └─ plugin no editor :9500 (WebSocket loopback autenticado, capacidades rotativas)
```

- Não conectou? Confira nesta ordem: plugin **ativo** no projeto → dock Godot AI aberto com status → `uvx` no PATH → **Configure** do dock para o seu cliente → cliente **reiniciado**. Reporte o passo que falhou; não declare conexão sem prova.
- Prova de conexão: `editor_state` respondendo (versão, projeto, cena atual, prontidão). Sessões de vários editores: `session_manage list` e fixe com `session_activate`/`session_id` por chamada — mudança na sessão errada é o erro caro do MCP.

## Ciclo de trabalho (sempre)

1. **Ler antes de mudar**: `editor_state` → `scene_get_hierarchy` (paginado: `depth/offset/limit`) → `node_get_properties` no nó-alvo. Caminho de nó é `/Main/Camera3D`, a partir da raiz da cena.
2. **Planejar a escrita mínima**: o que muda, em quais nós, e qual é a prova de que funcionou (rodar, log, screenshot).
3. **Escrever em lote atômico quando for uma unidade**: `batch_execute` roda comandos do plugin com rollback no primeiro erro — use para "criar personagem = corpo + colisão + câmera". (Dentro do lote e dos `*_manage`, o nome é o do **comando do plugin** — ex.: `node_create` vira `create_node`; na dúvida, o handler em `docs/TOOLS.md` manda.)
4. **Salvar e provar**: `scene_save`, `project_run` (salva edições em memória por padrão; `autosave=False` só quando souber por quê), `logs_read` e `editor_screenshot`.
5. **Olhar de verdade**: screenshot `viewport` (editor 3D), `viewport_2d`, `cinematic` (render da Camera3D) ou `game` (jogo rodando). Erro vermelho no editor/jogo aparece em `logs_read` com `source="editor"` — depois de qualquer erro de parse/reload, é lá que você confirma o conserto.
6. **Iterar pequeno**: uma hipótese por rodada (método da `agent-frontier-reasoning`): mudou, rodou, viu, corrigiu.

## Superfície (mapa rápido)

- **Sempre carregadas**: `editor_state`, `scene_get_hierarchy`, `node_get_properties`, `session_activate`.
- **Verbos diretos**: `node_create/set_property/find`, `scene_open/save`, `script_create/attach/patch`, `project_run`, `test_run`, `logs_read`, `editor_screenshot`, `editor_reload_plugin`, `animation_create`, `batch_execute`.
- **Domínios `*_manage`** (um `op` por verbo): `scene`, `node`, `script`, `project`, `editor`, `session`, `test`, `animation`, `material` (+ shader/VisualShader), `audio`, `particle`, `camera`, `signal`, `input_map`, `game` (árvore viva, UI do jogo, **injetar entrada**), `autoload`, `filesystem`, `theme`, `ui` (âncoras, texto, `build_layout`, `draw_recipe`), `resource` (incl. Environment, autofit de forma física, Gradient/Noise), `api` (ClassDB), `client`, `tilemap`, `tileset`, `gridmap`, `navigation` (bake, path), `csg` (`csg_create`, `csg_set_operation`), `custom`.
- **Resources `godot://…`** para leitura barata sem gastar ferramenta: `godot://editor/state`, `godot://scene/hierarchy`, `godot://node/{path}/properties`, `godot://class/{nome}`, `godot://script/{path}`, `godot://materials`, `godot://input_map`… Prefira resource para ler; ferramenta é para escrever e para fixar `session_id`.

Tabela de operações por domínio em [references/mapa-de-ferramentas.md](references/mapa-de-ferramentas.md); depuração e armadilhas em [references/depuracao-e-armadilhas.md](references/depuracao-e-armadilhas.md).

## Regras de segurança do MCP

1. **Escrita exige editor pronto**: se a resposta for `EDITOR_NOT_READY` (importando, recarregando, jogando), **espere** e releia o estado — não repita a escrita em rajada nem promova `data.sub_code` a outra coisa.
2. **Script pelo MCP é validado, arquivo solto não**: prefira `script_create/patch` (parse validado, hot-reload, outline) a escrever `.gd` por fora e torcer. C# é **só texto** aqui: build e erro de compilação se conferem no editor/`dotnet build`, nunca afirme que compilou pelo MCP.
3. **Jogo rodando é outra árvore**: inspecione/inpute no jogo com `game_manage` (inclusive `input_*` para testar de verdade), não confundindo com a cena do editor.
4. **Teste é ferramenta, não ritual**: suites GDScript do projeto rodam com `test_run` (`McpTestSuite`) e o resultado mora em `test_manage results_get`/`godot://test/results` — rode antes de dizer "pronto", junto com a suíte da skill de domínio quando houver.
5. **Sessão certa ou nenhuma**: com mais de um editor aberto, fixe `session_id` nas chamadas da tarefa; resource lê sempre a sessão ativa.
6. **Phantom/CSG pelo MCP**: PCams do Phantom Camera são nós comuns (`node_create/set_property` nas propriedades da skill `godot-phantom-camera`); formas do CSG Blockout idem, e CSG genérico tem `csg_manage` — o gesto de viewport do Blockout (desenhar/arrastar/congelar) continua sendo do criador no editor.

## Arquivos desta skill

| Arquivo | Conteúdo |
|---|---|
| [references/mapa-de-ferramentas.md](references/mapa-de-ferramentas.md) | Ferramentas e operações por domínio, resources e quando usar cada uma |
| [references/depuracao-e-armadilhas.md](references/depuracao-e-armadilhas.md) | Conexão, prontidão, sessões, erros frequentes e como provar conserto |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de mudanças da skill |
