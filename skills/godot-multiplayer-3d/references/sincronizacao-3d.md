# Sincronização 3D em detalhe

## Avatar remoto: rede × apresentação

Estrutura que funciona (nomes livres, papéis fixos):

```
Avatar (CharacterBody3D, autoridade = dono)
├── MultiplayerSynchronizer  (position/rotation/estado, da autoridade)
├── Corpo/apresentação       (malha + AnimationTree locais)
└── No remoto: simulação desligada; apresentação interpola para a posição de rede
```

- No dono: movimento normal da `godot-3d-specialist` (física, `move_and_slide`).
- No remoto: não rode a física decisiva do corpo contra o mundo como se fosse verdade — a posição de rede manda; a apresentação (malha) suaviza. Se o corpo remoto precisa existir para outros sistemas (ser atingido), quem arbitra o acerto é a autoridade comparando com a posição **de rede**, com tolerância declarada.
- Suavização: perseguir a posição de rede com interpolação por física (`lerp` com peso por distância, ou buffer de snapshots com atraso fixo pequeno). Distância grande demais (respawn, teleporte) = corte seco proposital, não perseguição atravessando o mapa: teleporte é evento, com `teleport`/corte declarado.

## Tiro e dano

- **Hitscan**: cliente mostra o traço na hora (feedback), servidor refaz o raycast da origem/direção recebidas (validando cadência, munição e origem plausível) e decide. Acerto "na minha tela" que o servidor nega é o preço normal da autoridade — feedback local não promete dano.
- **Projétil**: servidor spawna (Spawner) e é a autoridade do projétil; cliente pode previsualizar a saída sem hitbox decisiva.
- **Dano** passa pelo componente de vida do pacote (`HealthComponent` da `godot-3d-specialist`) **na autoridade**; o valor de vida sincroniza On Change, o evento de dano pode animar os dois lados sem duplicar a aplicação.

## Física compartilhada

- Corpo rígido que importa tem dono único (servidor por padrão). Remoto apresenta transform sincronizado com física local desligada/congelada. Alternar dono (pegar a caixa muda o dono) é evento explícito de transferência de autoridade, com o estado (transform + velocidades) no pacote da transferência.
- Veículo/montaria: autoridade de quem dirige, passageiros são apresentados — nunca dois corpos decidindo o mesmo chassi.

## Inimigos e multidão

- IA roda na autoridade (estado/perseguição da `godot-3d-specialist`); remoto recebe posição/estado e anima localmente.
- Interesse: ative sincronização por proximidade de **algum** jogador (visibilidade do Synchronizer), com histerese para não piscar na borda (entra a X m, sai a X+folga).

---
_Orientação criada em 2026-10-17 com base na documentação oficial de replicação da Godot 4.7 e na física do pacote. Tolerâncias de interpolação se calibram com latência simulada._
