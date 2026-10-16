# Registro visual: capturas, timelapses e a página de devlog

## Câmeras de devlog (imutáveis)

- Nó `DevlogCameras` na cena do nível, com `Camera3D` filhas em ângulos que contam a evolução do ambiente (geral, detalhe de prop, corredor). Alternativa equivalente: qualquer `Camera3D` no grupo `devlog_cameras`. O `DevlogRecorder` aceita os dois jeitos (sem duplicar) e avisa quando não encontra nenhuma — captura vazia nunca é silenciosa.
- Depois da primeira captura, **não mova** essas câmeras nem mude `fov`: antes/depois e timelapse só funcionam com enquadramento idêntico.
- Mudou o nível e a câmera ficou dentro de uma parede? Crie `cam_..._v2` e comece uma série nova; não edite a antiga.

## Captura e timelapse

Capturador pronto: [../scripts/devlog_recorder.gd](../scripts/devlog_recorder.gd) — numera os frames por câmera/etapa (`cam_main_step_0007.png`). Captura real exige renderização; em `--headless` o frame sai vazio e o script avisa em vez de gravar PNG em branco.

1. Capture frames numerados por câmera e etapa: `devlog/screenshots/cam_main_step_0001.png`, `0002`, ...
2. Monte o vídeo:

```bash
ffmpeg -framerate 12 -i devlog/screenshots/cam_main_step_%04d.png \
  -c:v libx264 -pix_fmt yuv420p devlog/timelapses/environment_evolution.mp4
```

3. Alternativa sem sair da Godot: `--write-movie` (ver [auditoria-e-validacao.md](auditoria-e-validacao.md)).

Capture sempre no mesmo estado de iluminação do marco (ex.: sempre com a luz final da etapa), para a comparação ser sobre geometria e material, não sobre exposição.

## A página HTML

Parta de [../templates/devlog.html](../templates/devlog.html) (arquivo único, tema escuro, sem dependência externa) e preencha as seções:

1. **Cabeçalho**: nome do jogo, versão da engine, estilo visual, barra de progresso e contadores (props, cenas, marcos, status da auditoria).
2. **Roadmap**: as 6 fases de [planejamento.md](planejamento.md) como cartões com checklist (feito / fazendo / pendente).
3. **Galeria**: `<video controls loop muted>` do timelapse e comparador antes/depois com slider (`input[type=range]` sobre duas imagens sobrepostas).
4. **Auditoria**: leia `audit_report.json` e mostre contagem por severidade; verde somente com 0 erros.
5. **Linha do tempo**: entradas datadas com captura, decisão técnica e link para o commit/entrega.
6. **Catálogo de props**: tabela filtrável (`tscn`, dimensões, pivô, colisor) gerada do catálogo de props.

Dados dinâmicos (auditoria, contadores) ficam em `devlog_data.js`/`audit_report.json` ao lado do HTML, para atualizar o painel sem reescrever a página.


---

_Última verificação: 2026-10-16, Godot 4.7.2 (suíte `tests/`). Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
