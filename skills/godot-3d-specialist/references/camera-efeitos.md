# Câmera 3D, partículas e efeitos

## Câmera de jogo

- Terceira pessoa: `SpringArm3D` entre o pivô e a `Camera3D` resolve parede encostando — câmera sem braço atravessa parede em corredor, que é onde o jogo acontece.
- A câmera **lê** o personagem (segue alvo com suavização), nunca o personagem lê a câmera para se mover, exceto a direção de movimento relativa à câmera, calculada no controlador.
- Oclusão além do braço: desvanecer obstáculo entre câmera e personagem é efeito posterior; primeiro garanta que a câmera não entra na geometria.
- Shake é camada aditiva com decaimento e teto (trauma acumulado com limite), separada do movimento base — shake no nó da câmera contamina todo o resto.
- Câmeras de devlog são outra coisa e não se movem nunca: ver [devlog-html.md](devlog-html.md).

## Partículas (GPUParticles3D)

- `amount` é orçamento: defina por efeito e some o pior caso em cena (três explosões juntas), não por efeito isolado.
- Caixa de emissão (`visibility_aabb` generosa ou AABB customizado) evita partícula sumindo ao sair do enquadramento padrão — sintoma clássico de "efeito some de lado".
- Chuva/neve/fumaça de ambiente seguem o jogador reciclando na caixa, não nascem no mapa inteiro.
- Subemissor para cadeia (explosão→faísca→fumaça) com vida útil curta; efeito eterno ligado é custo e ruído visual.
- Partícula é apresentação: dano, spawn e som disparam pelo sistema de gameplay, com a partícula escutando — nunca o contrário.

## Efeitos de cena que pedem dono

- Hit-stop, câmera lenta e flash de tela são serviços únicos com fila/prioridade; dois sistemas pedindo cámara lenta ao mesmo tempo precisam de arbitragem, não de sorte.
- Pós-processo: um passe de tela por efeito aprovado no orçamento (ver [materiais-e-shaders.md](materiais-e-shaders.md)).

---
_Referência revisada em 2026-10-16 (Godot 4.7.2). A suíte `tests/` prova os scripts do pacote; as receitas daqui são orientação de uso, não comportamento testado. Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._

> Direcao de camera com gramatica de planos e cutscenes vivem na skill companheira `godot-audio-cinematics`.
