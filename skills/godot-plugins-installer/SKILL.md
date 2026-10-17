---
name: godot-plugins-installer
description: Baixa e instala, somente das fontes oficiais, os plugins do fluxo Godot do criador — Phantom Camera (câmeras), CSG Blockout (blockout de nível) e Godot AI (MCP que conecta o agente ao editor) — com checagem de versão da engine, confirmação antes de sobrescrever e verificação pós-instalação. Use quando o criador pedir para instalar/atualizar esses plugins num projeto Godot, ou ao começar um projeto novo que deva tê-los.
---

# Godot Plugins Installer

Instale os três plugins do fluxo do criador **da fonte oficial, na versão certa para a engine, sem sobrescrever nada em silêncio**. Plugin errado ou de fonte errada quebra o projeto inteiro: aqui, procedência e versão são o trabalho.

Versões fixadas nesta skill (conferidas nos repositórios oficiais em 2026-10-17) em [references/catalogo-de-plugins.md](references/catalogo-de-plugins.md). Ao instalar, confira se saiu release mais nova e, se usar outra, registre a troca.

## Antes de baixar qualquer coisa

1. **Ache o projeto e a engine**: leia `project.godot` (`config_version`, recursos usados) e a versão da Godot do criador. Compatibilidade mínima: Phantom Camera 4.4+, CSG Blockout 4.6+, Godot AI 4.7+ (linha 4.x). Engine abaixo disso = **pare e reporte** qual plugin não entra e por quê — não force.
2. **O que já existe**: para cada `addons/<plugin>/plugin.cfg`, leia a versão instalada. Já instalado e atual → pule e diga. Já instalado e antigo → mostre atual → novo e **pergunte** antes de substituir. Godot AI instalado se atualiza pelo botão **Update** do próprio dock (migração v3→v4 é por ele), nunca extraindo zip por cima.
3. **Confirmação**: liste o que vai baixar (plugin, versão, tamanho/fonte) e espere o "sim". Instalação é escrita em disco de terceiro — não é passo silencioso.
4. **Godot fechado** para o projeto-alvo durante a cópia: addon trocado com o editor aberto gera importação pela metade.

## Instalar

Windows — rode [scripts/install_plugins.ps1](scripts/install_plugins.ps1) (baixa das URLs oficiais fixadas, recusa sobrescrever sem `-Force` e confere o `plugin.cfg` resultante — o asset certo do Godot AI é o `godot-ai-v4-plugin.zip`, **não** o `godot-ai-plugin.zip`, que é só a ponte de migração v3→v4):

```powershell
.\install_plugins.ps1 -Project <raiz-do-projeto>                  # os três
.\install_plugins.ps1 -Project <raiz-do-projeto> -Plugins phantom,csg
```

macOS/Linux ou instalação manual: siga o passo a passo por plugin em [references/catalogo-de-plugins.md](references/catalogo-de-plugins.md) — mesmas fontes, mesmo destino (`addons/phantom_camera`, `addons/csg_blockout`, `addons/godot_ai`, cada um com seu `plugin.cfg` dentro).

Depois da cópia, **habilite no editor** (o script não edita `project.godot` para você): Projeto → Configurações do Projeto → Plugins → ativar cada um. Phantom Camera ao ativar registra o autoload `PhantomCameraManager` — ele deve aparecer em Autoloads; Godot AI abre o dock próprio.

## Por plugin: o que confirmar depois

| Plugin | Prova de que instalou |
|---|---|
| Phantom Camera | `addons/phantom_camera/plugin.cfg` na versão esperada, autoload `PhantomCameraManager` presente, nós `PhantomCamera3D`/`PhantomCameraHost` criáveis |
| CSG Blockout | `addons/csg_blockout/plugin.cfg` presente, paleta de ferramentas no viewport 3D e menu `Shift+A` (tecla de ação configurável) |
| Godot AI | Dock **Godot AI** com status, `addons/godot_ai/plugin.cfg` presente; requer `uv` instalado (`uvx` no PATH) |

### Godot AI: ligar o agente (passo que não é opcional)

1. Confirme o `uv`: sem `uvx`, o servidor MCP não sobe — instale pela [documentação oficial do uv](https://docs.astral.sh/uv/getting-started/installation/) antes.
2. No dock do Godot AI, **Configure** no seu cliente (Antigravity, Claude Code, Codex…) ou **Configure all**; reinicie o cliente depois. Use **sempre** o comando gerado pelo dock — entrada manual `http://127.0.0.1:8000/mcp` não autentica (o v4 usa `godot-ai attach` via stdio com capacidades rotativas).
3. Teste a ligação com a skill `godot-ai-mcp`: `editor_state` deve responder com a cena atual. Sem resposta, não finja que conectou: reporte o passo que falhou (plugin ativo? `uvx`? cliente reiniciado?).

## Atualizar e remover

- **Atualizar**: Phantom/CSG = repetir a instalação com a release nova (com confirmação, por cima via `-Force` ou AssetLib); Godot AI = botão **Update** do dock. Nunca `git pull` dentro de `addons/` de instalação por release — a árvore deixa de corresponder a uma versão.
- **Remover**: desative o plugin nas Configurações do Projeto antes de apagar a pasta. Phantom: o autoload é removido ao desativar. Godot AI: use **Remove** no dock para limpar a configuração dos clientes. Projeto que usava nós do plugin (PCams, formas CSG do Blockout) perde a referência ao remover — avise antes: formas CSG nativas e blockout congelado sobrevivem; nós próprios do plugin, não.

## Nunca

- Baixar plugin de agregador, fork ou "pack de addons" — só os três repositórios oficiais do catálogo.
- Instalar versão sem conferir a engine (Blockout em 4.5, Godot AI em 4.6: não entra).
- Extrair release nova do Godot AI sobre a instalação antiga.
- Declarar sucesso sem abrir o `plugin.cfg` resultante e, no Godot AI, sem o `editor_state` responder.

## Arquivos desta skill

| Arquivo | Conteúdo |
|---|---|
| [references/catalogo-de-plugins.md](references/catalogo-de-plugins.md) | Os três plugins: fonte oficial, versão, engine mínima, destino, instalação manual e prova de instalação |
| [scripts/install_plugins.ps1](scripts/install_plugins.ps1) | Download das releases oficiais fixadas, cópia sem sobrescrever em silêncio e conferência do `plugin.cfg` |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de mudanças da skill |
