# Banda, interpolação e segurança

Multiplayer que funciona na sua rede local e morre na internet real foi testado no lugar errado. Este é o orçamento e a desconfiança que faltavam.

## Orçamento de banda (o que realmente custa)

- Custo ≈ propriedades × tamanho × frequência × peers que veem. Ataque nas quatro frentes: menos propriedades (posição sim, matriz de transformação não), tipos pequenos (índice em vez de string), intervalo maior (`replication_interval` 0.05–0.1 s para movimento; On Change para o resto) e visibilidade (peer só recebe o que sua área interessa — `set_visibility_for` e filtros).
- Evento contínuo disfarçado de RPC confiável todo frame é o vazamento clássico: confiável retransmite e ordena — caro e com atraso crescente. Contínuo = sincronização não confiável/intervalada; evento raro importante = RPC confiável.
- Meça: monitore peers e tráfego no teste com o número real de jogadores do design, não com 2 bonecos parados.

## Interpolação de remotos (suavidade sem custo de simulação)

- Remoto não teleporta a cada pacote: ele **interpola** entre as últimas posições conhecidas (buffer curto de snapshots, renderizar levemente "no passado") e extrapola com teto quando o pacote atrasa. Na Godot, o desenho comum: autoridade atualiza a posição real; nos remotos, um nó de apresentação persegue a posição sincronizada com `lerp`/suavização por física — nunca a física do remoto decidindo colisão a partir de posição velha sem saber disso.
- Rotação interpola junto (slerp), com o mesmo buffer; animação remota se deriva de velocidade/estado sincronizados, não de esqueleto sincronizado.
- Quanto de atraso visual é aceitável é decisão do gênero (tiro preciso × co-op tranquilo) registrada na ficha — e o atraso do remoto não pode virar vantagem (quem apresenta atrasado não acerta o presente).

## Segurança (desconfiança proporcional ao jogo)

1. **Toda entrada de RPC `any_peer` é hostil até validar**: tipo, faixa (dano entre X e Y?), dono (este peer pode mexer **neste** nó?), momento (a partida começou?). `get_remote_sender_id()` é a identidade — confira contra a autoridade do nó-alvo.
2. **Servidor decide o que tem valor**: dano, cura, economia, posição final em competitivo, vitória. Cliente sugere intenção; servidor concede ou nega (e a negação também é resposta, silenciosa ou avisada conforme o design).
3. **Visibilidade é anti-trapaça**: o que o cliente não recebe (inimigo atrás da parede, em outra área) ele não desenha nem com hack simples. Filtre por área/interesse, não por preguiça.
4. **Nunca confie em nome/arquivo do cliente**: nome exibido sanitizado e limitado; nada de executar recurso/código vindo de peer (o save do pacote já proíbe: rede, idem).
5. Co-op entre amigos pode relaxar validação cara — **declaradamente**, no checklist, não por esquecimento. Competitivo público sem validação de servidor é protótipo, não lançamento.

## Host-jogador (listen server) — o aviso honesto

O host é jogador e autoridade: tem vantagem (latência zero, vê tudo) e é o ponto de trapaça/desligamento (fechou, acabou para todos). Para co-op é o desenho certo e barato; para competitivo sério, servidor dedicado ou aceitar e declarar o limite.

---
_Orientação criada em 2026-10-17 a partir da documentação oficial (visibilidade, intervalos) e prática de rede de jogos. Valide constantes de intervalo jogando com latência real simulada, não só em LAN._
