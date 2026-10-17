# Sincronização 2D em detalhe

## Interpolação × snap de pixel (a decisão visual do 2D em rede)

- Avatar local: movimento em física + snap de pixel da arte (não nadar). É a verdade que a mão do jogador sente; nunca corrija o local com posição de rede em co-op de autoridade-do-dono.
- Avatar remoto, escolha registrada na ficha visual (`godot-2d-visual-craft`):
  - **Interpolação livre (sub-pixel)**: suave, mas o sprite "flutua" fora da grade — aceitável em arte HD/pintada e em pixel art com snap **desligado para remotos**.
  - **Interpolação com snap**: fiel à grade, mas anda em degraus na velocidade de chegada dos pacotes — mitigável com intervalo de sincronização curto e suavização antes do snap.
- O que não existe: os dois perfeitos ao mesmo tempo. Registre a escolha; não deixe o padrão decidir por acidente.

## Estado de movimento como dado

Sincronize o mínimo que a apresentação remota precisa: posição, direção olhando (flip), estado (chão/ar/dash/dano) e velocidade aproximada. A animação remota deriva disso localmente (a mesma tabela estado→animação da `godot-2d-visual-craft`), então pulo remoto tem pose de subida/ápice/queda sem sincronizar frame nenhum.

## Mundo em grade alterável

- Alteração de tile (quebrar, construir, abrir) é **decisão da autoridade**, aplicada por evento confiável a todos os presentes e gravada num registro de alterações (célula → novo tile) da sessão.
- Quem entra depois: recebe o registro (ou um snapshot das camadas alteradas) antes/junto do spawn — mapa base igual para todos não basta se o mapa muda.
- Tile com consequência (dano, trampolim) tem seu efeito decidido pela autoridade também; o visual da alteração pode ser imediato em quem fez (feedback), a verdade é a do evento.

## Inimigos simples e coletáveis

- Patrulha anda-e-volta e perseguição no mesmo andar são simulados **só na autoridade** (sensores/estados da `godot-2d-specialist`); remoto apresenta posição + estado. Inimigo barato é onde o 2D economiza banda: intervalo maior e On Change para estado bastam fora de combate.
- Coletável: quem encosta propõe; a autoridade marca coletado (estado/visibilidade sincronizados) e concede o efeito. Dois ao mesmo tempo → um ganha, o outro vê o item sumir sem efeito (e o log diz por quê).

## Co-op de câmera: os três desenhos

| Desenho | Leitura | Custo/escala |
|---|---|---|
| Câmeras independentes | Cada um no seu ritmo; podem se perder | Mundo deve funcionar com jogadores longe; UI de direção (seta para o parceiro) vira necessidade |
| Câmera de grupo/tether | Sempre juntos na tela (Phantom 2D Group/Framed) | Distância entre jogadores é regra do jogo (parede invisível, teleporte de quem ficou) — declare no design |
| Split-screen | Dois mundos visuais, mesma sessão (Viewports) | Custo de render dobrado; HUD por jogador |

Misturar (longe = independente, perto = grupo) sem regra clara vira câmera que muda de comportamento sem avisar: se existir, a transição é desenhada como nos modos da `godot-phantom-camera`.

---
_Orientação criada em 2026-10-17 com base na documentação oficial de replicação da Godot 4.7 e nas fichas 2D do pacote._
