# Sistemas de gameplay data-driven

Padrão comum a todos: **dado em `Resource`, comportamento em componente, identidade por `id` estável (String)**. Save guarda ids e números — nunca caminho de nó nem referência. Ver [save-load-3d.md](save-load-3d.md).

## Combate

- Dano viaja em pacote tipado (quantidade, tipo, origem) aplicado por um componente de vida — ver [../scripts/health_component.gd](../scripts/health_component.gd) (sinais `damaged/died`, i-frames, cura e revive testados).
- Hitbox (`Area3D` de quem ataca) × Hurtbox (área de quem recebe) em layers próprias da matriz de [fisica-e-consultas-3d.md](fisica-e-consultas-3d.md); golpe corpo-a-corpo ativa a hitbox por janela curta (track na animação), não permanentemente.
- Hitscan = raycast físico com exclude do atirador; projétil = corpo/área com pooling. Recoil e dispersão são dados da arma, não constantes no código do tiro.
- Feedback (hit-stop, shake, flash) escuta o evento de dano; o cálculo de dano não conhece efeito.

## Inventário e itens

- Item é `Resource` com `id`, nome, ícone e regras (empilhável, equipável); inventário guarda `{id, quantidade}` ou instâncias equipadas com estado próprio — separar "definição" de "instância" evita item único virando clone ao salvar.
- Grade é apresentação do mesmo modelo de lista; não deixe a grade mandar no dado.
- Loot é tabela de dados (peso por id) sorteada com RNG do sistema, testável por seed.

## Diálogo e quests

- Diálogo é grafo de nós (fala, escolha, condição, efeito) em dados; o apresentador (UI + voz) só executa o nó atual. Condição lê flags de quest por id.
- Quest é máquina de estados por etapas com objetivo contável (coletar/matar/chegar), progresso salvo por id da quest — nunca por texto exibido.
- Branching se valida alcançável: etapa sem caminho de entrada é soft-lock esperando acontecer (ver princípios abaixo).

## Economia e progressão

- Dinheiro em **inteiros** (centavos quando houver fração); float em economia acumula erro visível.
- Toda fonte (ganho) pede um sumidouro (gasto) desenhado junto; economia só-com-fonte é inflação com prazo.
- Stats derivam de base + modificadores listados (buffs com duração e origem), nunca de valor final editado por fora — remover o buff precisa desfazer exatamente o que ele fez.
- Habilidade é dado (custo, cooldown, efeito) executado por um componente; árvore de habilidades é grafo validado (pré-requisito existe e é alcançável).

## Loops e balanceamento

- Onda/coleta/colheita são máquinas de estado do encontro (preparar→ativo→recompensa→descanso) com números em dados, para ajustar sem tocar em código.
- Balanceamento por simulação (Monte Carlo) sobre os **mesmos dados** do jogo, com seed fixa e relatório de distribuição — planilha paralela desatualiza no primeiro ajuste.
- Reviver/checkpoint restaura estado por contrato do save, com lista do que reseta e do que persiste escrita no TDD.

## Princípios vindos dos gêneros (reutilizáveis)

- **Run × meta (roguelike)**: RNG com seed por partida; progresso permanente separado do temporário desde o primeiro save.
- **Ability-gating (metroidvania)**: mapa e saves assumem voltar com habilidade nova; porta que só abre por habilidade é dado do mapa, não script solto.
- **Validador de soft-lock (puzzle/metroidvania)**: toda etapa obrigatória precisa de caminho provado a partir de cada estado alcançável — teste de design, não de código.
- **Tick determinístico (simulação/idle)**: avanço por tempo decorrido calculado, não por frames; offline progress é a mesma função com delta grande.

---
_Última verificação: 2026-10-16, Godot 4.7.2 (suíte `tests/`). Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
