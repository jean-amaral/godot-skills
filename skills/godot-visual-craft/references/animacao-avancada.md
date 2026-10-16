# Animação avançada: movimento com peso

Complementa `godot-3d-specialist/references/animacao-3d.md` (estrutura);
aqui é a qualidade do movimento em si.

## Estudar movimento antes de animar

- Vídeo de referência do movimento real ou do personagem no estilo
  contratado, com os tempos marcados: contato, passagem, ápice, recuperação.
- Meça em frames a proporção entre as fases (descida rápida × subida lenta
  é o que lê como "peso"); animar "no sentimento" sem os tempos produz o
  flutuar clássico.
- Um movimento por vez: locomoção não se julga com ataque montado junto.

## Ciclos que convencem

- **Locomoção**: contato e passagem nítidos, quadril sobe/desce duas vezes
  por ciclo, braços em oposição. Velocidade da animação casada com a
  velocidade do corpo (pé que desliza = velocidade errada, não blend errado).
- **Idle vivo**: respiração e microequilíbrio em camada separada, amplitude
  mínima — idle "se mexendo muito" é personagem nervoso, não vivo.
- **Ataque em fases**: antecipação curta legível → golpe rápido → recuperação
  que o gameplay pode cancelar. As três fases têm tempos próprios e o
  evento de dano mora no frame de contato, não no início.
- **Transições**: crossfade curto entre estados vizinhos; corte seco só
  onde o impacto pede (dano, pouso).

## Root motion e IK

- Fonte única de movimento: ou a animação desloca (root motion aplicado
  ao corpo), ou o código desloca (root desligado). Misturar dobra velocidade.
- IK de pé em desnível e de mão em alvo são camadas sobre o blend, com
  peso por contexto (subindo escada ≠ andando no plano) — API por versão
  no pacote-mãe (`IKModifier3D` × `SkeletonIK3D`).
- Olhar (look-at) com limite de ângulo e velocidade: cabeça que gira
  instantaneamente quebra qualquer realismo vizinho.

## Procedural como tempero

Respiração, balanço de equipamento, recoil e tremida entram por
código/tween **sobre** a animação autorada, em camada aditiva pequena.
Procedural substituindo a animação principal lê como boneco de pano.

---
_Referência revisada em 2026-10-16 (Godot 4.7.2). A suíte `tests/` prova os scripts do pacote; as receitas daqui são orientação de uso, não comportamento testado. Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
