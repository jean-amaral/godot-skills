# Otimização medida (monitores e profiler oficiais)

## Orçamento e onde olhar

- Frame de 60 fps = **16,6 ms** no total. Monitores `Performance` (painel Monitor do Debugger ou `Performance.get_monitor()`): `TIME_FPS`, `TIME_PROCESS`, `TIME_PHYSICS_PROCESS`, tempos de render, `RENDER_TOTAL_DRAW_CALLS_IN_FRAME`, `RENDER_TOTAL_PRIMITIVES_IN_FRAME`, `MEMORY_STATIC`, contagem de objetos/nós/corpos físicos. Alguns monitores só existem em build debug (em release retornam 0 — meça no alvo certo, sabendo disso).
- Monitor customizado do jogo (`add_custom_monitor("jogo/inimigos_ativos", ...)`) entra no mesmo painel: o número do **seu** sistema ao lado do da engine.
- Profiler do Debugger ordena funções por tempo: ataque o topo **medido na cena pesada real** (pior multidão, pior vista), com captura salva para comparar depois.

## Otimizações por sistema (com o dono certo)

| Sintoma medido | Causa provável | Correção típica |
|---|---|---|
| Processo (script) alto | `_process` em tudo, polling, conta por frame em coleções grandes | Sinal/evento em vez de polling, processar só o ativo, espaçar trabalho (fila por frame) |
| Física alta | Corpos/áreas demais, shapes complexos, monitoramento sempre ligado | Camadas enxutas, áreas ligadas só na janela, formas simples, dormir/desligar o distante |
| Draw calls altas | Muitos nós/materiais únicos pequenos | MultiMesh para repetição, atlases/materiais compartilhados, culling por visibilidade/distância |
| Primitivas/memória altas | Malha/textura acima do orçamento do alvo | LOD, compressão de textura por alvo, streaming do mundo (referências do pacote 3D) |
| Picos (hitch) | Instanciar/destruir em rajada, load síncrono, shader compilando na cena | Pooling, carga threaded/precarga, pré-aquecimento de shader/material |
| Vazamento (memória sobe sem voltar) | Referência presa, nó não liberado, Tween/Timer órfão | Contagem de objetos no monitor ao entrar/sair da cena; dono claro para cada peça criada (engine-resources) |

## Processo honesto

1. Cenário de medição fixo e salvo (a pior cena jogável, com roteiro de câmera/ações).
2. Número antes (FPS médio **e** pior frame — média esconde o tranco).
3. **Uma** mudança, a do maior item.
4. Mesmo cenário, número depois. Piorou ou não mexeu? Reverta sem apego e ataque o próximo item.
5. Registre no relatório ([templates/relato-de-problema.md](../templates/relato-de-problema.md)): cenário, antes, depois, hardware. "Otimizei o jogo" sem essa linha não aconteceu.

## Erros clássicos

- Otimizar o menu (leve) e declarar vitória sobre a fase pesada.
- Micro-otimizar script enquanto draw call estoura (o profiler já tinha dito).
- Medir no editor e lançar para hardware fraco: o editor não é o alvo (`godot-export-release` testa o build).
- Pooling/MultiMesh "porque sim" sem medição: complexidade nova também se prova com número.

---
_Referência criada em 2026-10-17 a partir da classe `Performance` e do Debugger oficiais (Godot 4.7). Monitores disponíveis variam entre debug/release: meça sabendo em qual build está._
