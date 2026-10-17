# HUD e hierarquia de informação

HUD bom responde, sem o jogador procurar: **estou morrendo? o que faço agora? o que mudou?** Todo o resto é secundário — e secundário que disputa atenção vira ruído.

## Hierarquia por pressão de leitura

Classifique cada elemento antes de posicionar:

| Classe | Pergunta que responde | Leitura | Exemplos |
|---|---|---|---|
| Crítico | "Vou perder agora?" | Periférica, instantânea, redundante | Vida baixa, recurso zerado, ameaça iminente |
| Frequente | "Como estou?" | Periférica, sob demanda do olhar | Vida/munição/estado normais, objetivo atual |
| Contextual | "E aqui, o que dá pra fazer?" | Perto do foco, só quando serve | Prompt de interação, dica do objeto mirado |
| Raro | "Quero detalhes" | Fora do HUD (menu/pausa) | Estatísticas, inventário completo, codex |

Regra de ouro: se tudo é crítico, nada é. Elemento frequente que nunca muda de estado deve encolher, ficar translúcido ou ir para o menu.

## Zonas (consistência vende leitura)

- Cantos são memória muscular: escolha um canto por papel (ex.: estado do personagem embaixo à esquerda, objetivo em cima à direita) e **não troque entre telas/mod os**.
- O centro e o terço inferior central são do mundo: mira e prompts mínimos moram ali; barra, retrato e texto longo, não.
- Agrupe por relação, não por sobra de espaço: vida+escudo+efeito ativo formam um bloco com uma leitura; munição mora com a arma que a consome.
- Alinhe a uma grade (margens e espaçamentos do `Theme`); elemento "quase alinhado" lê como erro mesmo sem o jogador saber por quê.

## Estados sem depender de cor

Cada estado importante se distingue por **pelo menos duas** camadas:

- Forma/ícone (cheio, vazado, ícone de alerta), tamanho ou posição;
- Texto curto ("CRÍTICO", número, nome do efeito);
- Movimento (pulso com teto de repetições) — e só então a cor.

Isso resolve daltonismo, tela lavada pelo cenário e captura de vídeo comprimida, tudo de uma vez.

## HUD contextual e presença

- Prompt aparece quando a ação existe (alcance + condição), some quando ela some — sem piscar por entrar/sair de trigger a cada frame (histerese: mostre rápido, esconda com atraso curto).
- Fora de pressão, HUD frequente pode reduzir presença (opacidade/tamanho configuráveis); em combate, volta sozinho. Jogador controla o teto nas configurações.
- Barra contínua (vida, progresso) atualiza suavizada por interpolação para o alvo; número e eventos (dano/cura) são imediatos — suavizar o número atrasa a verdade.

## Erros clássicos

- HUD de MMO em jogo de ação: doze barras disputando o canto.
- Informação crítica atrás de ícone sem texto na primeira vez que aparece.
- Dano/morte comunicados só por som ou só por flash de tela cheia.
- Minimapa como resposta para orientação que o nível deveria dar.

---
_Orientação de design revisada em 2026-10-17 para Godot 4.7+. Valide na engine e com teste de tarefa: hierarquia se prova com jogador, não com captura bonita._
