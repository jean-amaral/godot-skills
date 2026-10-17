# godot-skills

Pacote de skills Godot para agentes de código (Antigravity, OpenCode, Codex e
Claude): desenvolvimento 3D com padrão de qualidade alto, assets gratuitos
com licença verificada, criação visual e áudio/cinematografia — sempre com
pesquisa e referências antes de construir.

**Versão do pacote: `v1.2.0-10.2026`** (ver [VERSION](VERSION) e [releases](#versões))

## Skills incluídas

| Skill | Para quê |
|---|---|
| `godot-3d-specialist` | Jogo 3D na Godot 4.7+: concepção por entrevista, planejamento, CSG→bake, props modulares realistas, auditoria headless, save/load e devlog |
| `godot-free-assets` | Buscar e baixar assets **100% gratuitos (só CC0/CC-BY)** compatíveis com o projeto, com crédito e checksum |
| `godot-visual-craft` | Shaders realistas, materiais PBR avançados e animação com peso |
| `godot-audio-cinematics` | Direção de áudio, cutscenes com pulo seguro e gramática de câmera |

## Instalação

Cole este texto na sua IA:

```text
Instale as skills "https://github.com/jean-amaral/godot-skills.git" para serem usadas pelo Antigravity, e lembre-se de sempre procurar por atualizações quando iniciar.
```

A IA faz todo o processo automaticamente e tenta se manter atualizada.
Troque `Antigravity` pelo seu agente, se for outro.

Para desinstalar, peça: `Desinstale as skills de "https://github.com/jean-amaral/godot-skills.git" instaladas para o Antigravity.`

## Versões

- **Pacote**: `v1.0.0-10.2026` foi a primeira distribuição pública. A
  vigente, `v1.2.0-10.2026`, não tem scripts de instalação nem skill de
  atualização: instalar é colar o texto acima na IA, e é ela quem procura
  atualizações ao iniciar. Conteúdo validado na Godot 4.7.2 (suítes de
  teste dentro de cada skill, em `tests/`).
- Cada skill mantém seu histórico interno no próprio `CHANGELOG.md`.

## Desenvolvimento

As suítes ficam dentro de cada skill (`skills/<skill>/tests/run_tests.ps1`,
requerem uma Godot 4.7+ via `GODOT_PATH`). Rode-as antes de publicar
mudança em `scripts/` ou `shaders/` de qualquer skill.
