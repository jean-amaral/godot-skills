---
name: godot-audio-cinematics
description: Direção de áudio, cutscenes e câmera cinematográfica na Godot 4.7+ — mix por barramentos, som 3D, música adaptativa, sequências com AnimationPlayer, gramática de planos e movimento de câmera, sempre a partir de pesquisa com referências. Use quando o criador pedir trilha, efeitos sonoros, cutscene, cena de história ou direção de câmera em projeto Godot.
---

# Godot Audio & Cinematics

Som e câmera são direção, não enfeite: **pesquisa primeiro (filme, jogo e som de referência analisados), plano escrito, construção, comparação**. Cutscene sem plano de câmera é gameplay com a câmera quebrada; som sem referência é volume no escuro.

## Quando usar

- Montar o áudio do jogo: barramentos, música adaptativa, SFX, som 3D posicional, mix.
- Criar cutscene (história, apresentação de área/chefe, transição) com controle de pulabilidade e retorno limpo ao gameplay.
- Dirigir câmera: plano, movimento, corte, FOV e enquadramento — em cutscene e em câmera de jogo (terceira pessoa, mira, diálogo).

Arquitetura, cena e auditoria continuam no pacote-mãe `godot-3d-specialist`; assets sonoros gratuitos licenciados vêm da `godot-free-assets`.

## Protocolo de pesquisa (obrigatório, antes de criar)

1. **Referências analisadas**: a cena/filme/jogo que é o alvo — extraia gramática (tipos de plano, quando corta, o que o som está fazendo em cada batida), não "o clima" em abstrato. Registre como em `godot-3d-specialist/templates/painel-referencias.md`, adaptado a tempo/planos/som.
2. **Som se estuda ouvindo com fone e anotando camadas**: o que toca em cada momento (ambiente, ação, música, silêncio) e a que distância parece estar.
3. **Plano antes do editor**: cutscene nasce em shot list (plano, duração, câmera, som, saída) — [templates/shot-list.md](templates/shot-list.md) — e áudio nasce em mapa de mix (quem toca, em qual barramento, com que prioridade).
4. **Comparação**: assista/ouça o resultado ao lado da referência, no volume de jogo, e corrija batida por batida.

## Padrões por disciplina

### Áudio

- Barramentos por papel (Master/Música/SFX/UI/Voz/Ambiente), volume do jogador salvo por barramento, nada direto no Master — detalhe em [references/audio-direcao.md](references/audio-direcao.md).
- Som do mundo é posicional 3D com distância calibrada ao nível; música muda por **estado** (exploração/combate/história) com transição, não por corte seco.
- Silêncio é ferramenta: cena que nunca cala não tem pico.

### Cutscenes

- Sequência no `AnimationPlayer` (câmera, atores, método/áudio nas tracks) dirigida pelo [scripts/cutscene_player.gd](scripts/cutscene_player.gd): tocar, marcar batidas por sinal e **pular** sem quebrar estado (pular = ir ao estado final + `finished`, nunca "parar no meio").
- Ao entrar: salva e desliga o controle do jogador; ao sair (fim ou pulo): devolve exatamente o que desligou. Letterbox é apresentação (CanvasLayer), não mudança de resolução.
- Cutscene não é lugar de lógica de gameplay: ela **pede** os estados (porta aberta, item entregue) por sinal/método no fim da batida certa.

### Direção de câmera

- Gramática antes de movimento: plano aberto situa, médio relaciona, close emociona; corte tem motivo (ação, olhar, informação nova) — [references/direcao-camera.md](references/direcao-camera.md).
- Câmera se move com intenção e easing; FOV é linguagem (aberto comprime menos, fechado isola). Regra dos terços e linha de olhar valem em 3D interativo também.
- Em gameplay, a câmera serve ao controle (o pacote-mãe cuida do SpringArm); em cutscene, serve à cena — nunca misture os dois donos no mesmo nó ao mesmo tempo.

## Arquivos desta skill

| Arquivo | Conteúdo |
|---|---|
| [references/audio-direcao.md](references/audio-direcao.md) | Barramentos, música adaptativa, SFX, som 3D e mix |
| [references/cutscenes.md](references/cutscenes.md) | Estrutura de cutscene, batidas, pulo seguro e retorno ao gameplay |
| [references/direcao-camera.md](references/direcao-camera.md) | Gramática de planos, movimento, corte e FOV |
| [scripts/cutscene_player.gd](scripts/cutscene_player.gd) | Tocador de cutscene com batidas por sinal e pulo ao estado final |
| [templates/shot-list.md](templates/shot-list.md) | Plano de cena: planos, durações, câmera, som e saídas |
| [tests/README.md](tests/README.md) | Como o tocador de cutscene é validado na engine |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de mudanças da skill |
