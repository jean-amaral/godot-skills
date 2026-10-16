# Animação 3D

## AnimationPlayer sem surpresa

- Toda animação que mexe em propriedade editável no editor ganha track **RESET**: sem ela, parar no meio deixa o personagem torto/congelado entre poses.
- Evento de gameplay (passo, golpe, som) entra por track de método/áudio na animação, não por temporizador paralelo no script — os dois dessincronizam na primeira troca de velocidade.
- `speed_scale` muda duração de tudo naquela animação, inclusive os eventos: recalibre o evento, não compense no código.
- Animação importada de `.glb`: confira nomes e loops no import; correção de loop se faz no asset ou em cópia do recurso, não "no play".

## AnimationTree quando o blend manda

| Necessidade | Estrutura |
|---|---|
| Locomotion parado↔andando↔correndo | `BlendSpace2D` (direção × velocidade) |
| Estados discretos (idle, ataque, dano, morte) | `StateMachine` de animação |
| Camadas (corpo inteiro + mirar/segurar por cima) | `BlendTree` com blend por osso/filtro |
| Transição suave pontual | `Transition` com tempo de crossfade |

- Parâmetro de árvore tem nome estável e dono único (o controlador do personagem escreve; ninguém mais).
- Máquina de animação **reflete** o estado de gameplay; ela não decide gameplay. Dano termina pelo dado, não pelo fim da animação (a animação pode ser interrompida).
- Root motion: ou o movimento vem da animação (aplique o deslocamento dela no corpo), ou vem do código (desligue o root motion). Os dois juntos = personagem deslizando ou dobrando velocidade.
- IK de pé/mão sobre terreno é camada posterior ao blend ( modificador de esqueleto), com peso por contexto — ver regra de versão no [SKILL.md](../SKILL.md) para `IKModifier3D` × `SkeletonIK3D`.

## Checklist de importação animada

1. Escala e eixos conferidos na primeira pose (personagem deitado = eixo do Blender).
2. Loops marcados e RESET testado parando a animação no meio.
3. Eventos de passo/golpe sincronizados assistindo, não lendo tempos.
4. Blend testado nas fronteiras (parado→correndo direto, sem passar pelo andando).

---
_Referência revisada em 2026-10-16 (Godot 4.7.2). A suíte `tests/` prova os scripts do pacote; as receitas daqui são orientação de uso, não comportamento testado. Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._

> Acabamento de movimento (peso, fases de ataque, idle vivo, procedural) vive na skill companheira `godot-visual-craft`.
