# Depuração e armadilhas (Godot AI MCP)

## Não conecta / cliente não enxerga o servidor

Confira **nesta ordem** e reporte o primeiro que falhar:

1. Projeto certo aberto, Godot **4.7+**, plugin **Godot AI ativo** (dock visível). Plugin fora de `addons/godot_ai/plugin.cfg` (ex.: `addons/plugin.cfg`) nem aparece na lista.
2. `uvx` no PATH da máquina (o servidor Python sobe via `uv`). Sem `uv`, nada depois importa.
3. No dock: **Configure** (ou **Configure all**) para o seu cliente — o comando válido é o `godot-ai attach` gerado ali. Achar que "basta apontar para `http://127.0.0.1:8000/mcp`" é o erro clássico do v4: sem as capacidades rotativas, não autentica.
4. **Reiniciar o cliente** após configurar (configuração nova em cliente aberto costuma não ser relida).
5. Escopo da configuração: clientes CLI gravam em escopo global por padrão; `godot_ai/mcp_client_scope` nas Editor Settings muda para projeto/local — reconfigure depois de trocar. Godot aberto a partir da pasta do projeto evita configuração gravada no lugar errado.
6. Atualização: usar o **Update** do dock; não extrair zip novo sobre a árvore antiga. Migração v3→v4 é pela release final v3 (um clique, editor reinicia, clientes migrados).

Privacidade: telemetria sai por padrão (sem código/cenas/nomes); `GODOT_AI_DISABLE_TELEMETRY=true` desliga de verdade (nem UUID é criado).

## `EDITOR_NOT_READY` e escritas que "somem"

- O servidor recusa escrita quando o editor está importando, recarregando plugin ou em transição de play. Resposta certa: esperar, reler `editor_state`, repetir **uma** vez. Rajada de repetições só fabrica erro duplicado.
- `project_run` persiste as edições feitas pelo MCP (autosave). Se você editou, não salvou e não rodou, a mudança pode existir só em memória — `scene_save` é o seu amigo antes de fechar qualquer coisa.
- Mudança "que não pegou": confira sessão (`session_activate`), cena aberta (`editor_state`) e caminho do nó (`/Main/...` a partir da raiz, não o caminho interno da Godot).

## Parse, reload e o erro que volta

- Crie/edite script por `script_create`/`script_patch`: o retorno já diz se o parse passou e o hot-reload aconteceu. Escrever `.gd` por fora e recarregar na mão pula a validação.
- Depois de erro de parse/reload ou de @tool/EditorPlugin: `logs_read` com `source="editor"` mostra parse, warnings e linhas do Debugger — confirme o conserto ali, não na ausência de reclamação do cliente.
- Plugin do Godot AI mexido/atualizado: `editor_reload_plugin` e aguarde reconectar antes de qualquer chamada.

## C# pelo MCP (limite honesto)

`script_create/patch` escrevem `.cs` e `find_symbols` delineia, mas o MCP **não compila .NET** nem devolve erro de compilação. Build é no editor (painel Build) ou `dotnet build` no terminal. Nunca entregue C# "verificado" só porque o MCP escreveu o arquivo — e anexar `.cs` pede build .NET do editor.

## Dois editores, um servidor (sessões)

- `session_manage list` mostra os editores ligados (`<projeto>@<hex>`); fixe a tarefa com `session_activate` ou `session_id` por chamada (nos `*_manage`, `session_id` é irmão de `op`, **fora** de `params`).
- Resources (`godot://…`) leem sempre a **sessão ativa**: com dois editores, resource pode estar mostrando o projeto "errado" sem erro nenhum. Para ler do editor certo, ferramenta com `session_id`.

## Screenshot que não prova nada

- Viewport do editor ≠ jogo: `cinematic`/`game` provam câmera e HUD de verdade; `viewport` prova a cena no editor.
- Captura antes do `project_run` ficar vivo, ou durante loading, "prova" uma tela que não é a do jogo. Espere liveness, capture, **olhe** a imagem (ou a descrição do Vision Routing) antes de concluir.

---
_Armadilhas conferidas em 2026-10-17 na documentação oficial (`docs/TOOLS.md`, `docs/client-configuration.md`, README do v4.3.0)._
