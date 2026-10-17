# Catálogo de plugins (fontes oficiais)

Conferido nos repositórios oficiais em 2026-10-17. Antes de instalar, verifique se há release mais nova; se usar outra versão, registre a troca para o criador.

## Phantom Camera — `ramokz/phantom-camera`

- **Para quê**: comportamento de câmera estilo Cinemachine para `Camera2D`/`Camera3D` (seguir, olhar, transições entre câmeras virtuais). Licença MIT.
- **Versão fixada**: `v0.11.0.3` · **Engine**: Godot 4.4+ · **Destino**: `addons/phantom_camera/` (com `plugin.cfg`, versão `0.11.0.3`).
- **Fonte**: [releases](https://github.com/ramokz/phantom-camera/releases) (o zip da release é o código-fonte: dentro dele, copie a pasta `addons/phantom_camera`) ou a AssetLib dentro do editor ("Phantom Camera", selecionar só a pasta `phantom_camera`).
- **Ao ativar**: registra o autoload `PhantomCameraManager` e os tipos `PhantomCamera2D/3D`, `PhantomCameraHost`, emissores de ruído e `PhantomCameraTweenDirector`. Também tem nós C# (projeto .NET recebe as duas APIs; GDScript basta).
- **Trabalhar com ele**: skill `godot-phantom-camera`. Documentação: [phantom-camera.dev](https://phantom-camera.dev/).

## CSG Blockout — `qwqzhanqwq/Godot-CSG-Blockout`

- **Para quê**: blockout/prototipagem de nível com nós CSG nativos no viewport (desenhar cômodos, cortar portas/janelas, medir contra o personagem, congelar em malha reversível). Licença MIT. "Level prototyping, not modeling."
- **Versão fixada**: `v3.1.0` · **Engine**: Godot 4.6+ · **Destino**: `addons/csg_blockout/` (o repositório **é** a raiz do plugin: `plugin.cfg` na raiz dele).
- **Fonte**: AssetLib (recomendado pelo autor, "CSG Blockout") ou [releases](https://github.com/qwqzhanqwq/Godot-CSG-Blockout/releases) — asset `csg_blockout-3.1.0.zip`, de onde se copia `addons/csg_blockout`.
- **Ao ativar**: paleta de ferramentas à esquerda do viewport 3D, menu circular `Shift+A` (tecla de ação em `addons/csg_blockout/action_key`) e classes `CSGStairs3D`, `CSGArch3D`, `CSGCurvedWall3D`, `CSGWedge3D`, `CSGSpiralStairs3D`, `CSGRepeater3D`, `CSGSpreader3D`, `CSGPlayerReference3D`.
- **Trabalhar com ele**: skill `godot-csg-blockout`. Tutorial oficial: `TUTORIAL_EN.md` no repositório.

## Godot AI — `hi-godot/godot-ai` (o MCP)

- **Para quê**: servidor MCP que liga clientes de IA (Antigravity, Claude Code, Codex, Cursor, VS Code…) ao editor Godot vivo — 46 ferramentas, 120+ operações: cenas, nós, scripts, UI, materiais, animação, câmera, testes e screenshots. Licença MIT.
- **Versão fixada**: `v4.3.0` · **Engine**: Godot 4.7+ (linha 4.x) · **Pré-requisito**: [`uv`](https://docs.astral.sh/uv/getting-started/installation/) (`uvx` no PATH). GDScript completo; C# só texto (sem build/erros pelo MCP).
- **Destino**: `addons/godot_ai/` com `plugin.cfg` dentro (não `addons/plugin.cfg`).
- **Fonte**: [releases](https://github.com/hi-godot/godot-ai/releases) — asset **`godot-ai-v4-plugin.zip`** (o plugin completo, `name="Godot AI"`, ~300 arquivos), com manifesto assinado `godot-ai-v4-plugin.manifest.json`/`.sig` ao lado: siga as instruções de verificação da release. **Armadilha**: o asset `godot-ai-plugin.zip` é só a ponte de migração v3→v4 ("Godot AI v4 Migration") — instalá-lo no lugar do plugin deixa o projeto sem o MCP de verdade. Não instale snapshot do código-fonte por cima de instalação existente; atualização é pelo botão **Update** do dock.
- **Ao ativar**: dock **Godot AI** sobe o servidor (HTTP local porta 8000, WebSocket do editor 9500, ambos autenticados com capacidades rotativas) e oferece **Configure**/**Configure all** para registrar o cliente MCP com o comando `godot-ai attach` (stdio). Entrada manual com URL crua não autentica.
- **Privacidade**: telemetria (UUID, evento, duração, versão — sem código/cenas) sai por padrão; desligue com `GODOT_AI_DISABLE_TELEMETRY=true` no ambiente, se o criador preferir.
- **Trabalhar com ele**: skill `godot-ai-mcp`. Catálogo de ferramentas: `docs/TOOLS.md` no repositório.

## Instalação manual (qualquer sistema)

1. Baixe da fonte oficial acima e verifique checksum quando publicado.
2. Extraia e copie **a pasta do addon** para `<projeto>/addons/<nome>` — o `plugin.cfg` tem que ficar em `<projeto>/addons/<nome>/plugin.cfg`.
3. Feche e reabra o projeto; Projeto → Configurações do Projeto → Plugins → ativar.
4. Prove a instalação pela tabela da SKILL.md antes de dizer "instalado".

---
_Catálogo criado em 2026-10-17 a partir dos repositórios oficiais. Versão de plugin muda: confira a release vigente no dia da instalação._
