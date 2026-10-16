# Produção e qualidade: build, teste e performance

## Pipeline de entrega

1. `godot --headless --import --quit` limpo (sem erro nem asset faltando).
2. Suíte headless do projeto (a desta skill é o modelo: [../tests/README.md](../tests/README.md)) com timeout por etapa.
3. Auditor de cenas com 0 erros — [auditoria-e-validacao.md](auditoria-e-validacao.md).
4. Export a partir de `export_presets.cfg` versionado; preset se muda em revisão, não na máquina de quem exporta.
5. Build exportado aberto e jogado fora do editor (caminho, save em `user://` e entrada testados no binário).

Assinatura/notarização e upload (Steam etc.) são etapa posterior ao export funcionar localmente, com credencial fora do repositório (variável de ambiente/segredo de CI), nunca no projeto.

## Teste que vale manter

- Teste de sistema (save, economia, dano) roda headless e rápido; teste de "cena abre sem erro" pega recurso quebrado.
- Golden test para saída determinística (geração com seed, formato de save) compara com arquivo aprovado — mudou de propósito, atualiza o golden na mesma revisão.
- Fuzz leve no carregamento: save truncado, campo faltando, tipo trocado — o loader precisa recusar sem aplicar nada (o `SaveSystem` desta skill já é testado assim).

## Performance: profiler primeiro

- Meça com o Profiler na **pior cena conhecida** antes de otimizar qualquer coisa; otimização sem medida é chute com custo.
- Ordem usual de ganho em 3D: visibilidade/oclusão e alcance de câmera → número de luzes dinâmicas com sombra → draw calls (instanciamento/`MultiMeshInstance3D` para repetição) → física (formas simples, layers enxutas) → script.
- Pooling para o que nasce e morre toda hora (projétil, partícula lógica, dano flutuante): instanciar/destruir em pico é o travamento periódico clássico. Pool preguiçoso sem teto é vazamento com outro nome — defina tamanho.
- Acesso direto aos servidores (`PhysicsServer3D`/`RenderingServer3D` por RID) só quando a contagem de objetos provar necessidade (enxames, multidão): ganha escala, perde a conveniência e a segurança do nó. Decisão registrada no TDD com o número que a justificou.
- Orçamentos escritos (frame alvo, luzes por sala, draw calls por cena) entram no auditor/TDD; orçamento sem número não se verifica.

## Logs e diagnóstico

- Log estruturado mínimo em build de teste: instante, sistema, evento — e relatório de auditoria anexável ao bug. `print` solto some no build exportado; defina o canal desde cedo.
- QA visual por captura comparada (as câmeras fixas do devlog servem): mesma câmera, mesmo seed, diff revisado por humano.

---
_Última verificação: 2026-10-16, Godot 4.7.2 (suíte `tests/`). Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
