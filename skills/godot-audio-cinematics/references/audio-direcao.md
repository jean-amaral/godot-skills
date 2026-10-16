# Direção de áudio: mix, música e som 3D

## Barramentos (a mesa antes dos sons)

```text
Master
├── Musica      (trilha, por estado do jogo)
├── SFX         (mundo: tiro, impacto, passo, mecanismo)
├── Ambiente    (vento, sala, natureza — loops longos)
├── Voz         (diálogo e narração; prioridade sobre o resto)
└── UI          (menu, confirmação, erro)
```

- Volume do jogador por barramento, salvo nas configurações (nunca volume
  "na fonte" espalhado por player).
- Voz na frente: quando a fala toca, música e ambiente abaixam alguns dB
  (ducking por automação de volume do barramento, com retorno suave).
- Efeito (reverb de caverna, eco de corredor) é no barramento da **zona**,
  trocado ao mudar de área — não um player com efeito por som.

## Música adaptativa

- Estados nomeados (exploração, tensão, combate, história, vitória) com
  crossfade entre eles; transição tem duração musical (compasso/fim de
  frase quando o sistema permitir), não timer cru.
- Camadas verticais quando o orçamento permite: base sempre, camada de
  combate entra/sai por intensidade. Duas trilhas inteiras se alternando
  é o começo; camada é o refinamento.
- Silêncio programado: antes do chefe e depois da vitória, a ausência de
  música é o destaque. Marque no mapa de mix, não improvise.

## SFX com intenção

- Cada som tem dono e evento: nasce do evento de gameplay/animação
  (passo na track, impacto no hit), nunca de temporizador solto.
- Variação por sorteio curto de pitch/volume dentro de faixa medida —
  repetição idêntica é o que entrega "som de jogo" em 10 minutos.
- Pool de players para som frequente (tiro/passo/impacto) com round-robin;
  distância e unidade do `AudioStreamPlayer3D` calibradas ao tamanho do
  nível (som que atravessa o mapa inteiro quebra a direção espacial).
- Som gratuito licenciado entra pela skill `godot-free-assets` (CC0/CC-BY
  com crédito); som de referência é para estudar timbre e camada.

## Mix de verdade

Mixa-se no volume de jogo, com fone e na caixa ruim do notebook: se o
diálogo some na caixa ruim, a mix está errada, não o alto-falante.
Ordem de trabalho: diálogo > ação do jogador > música > ambiente.

---
_Referência revisada em 2026-10-16 (Godot 4.7.2). A suíte `tests/` prova os scripts do pacote; as receitas daqui são orientação de uso, não comportamento testado. Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
