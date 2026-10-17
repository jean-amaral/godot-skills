# Feedback, estados e microanimação de UI

Jogador confia no que a interface confirma. Sem feedback, ele aperta de novo, acha que quebrou ou não percebe que funcionou.

## Todo elemento interativo tem estados desenhados

`normal · hover · foco · pressionado · desabilitado · selecionado/ativo` — e os de **valor**: `carregando · sucesso · erro · vazio`. Estado faltando na `Theme`/variação é estado que a engine improvisa (geralmente invisível).

Desabilitado explica o porquê (tooltip/texto "requer nível 5"), senão parece bug. Selecionado se distingue de focado: são duas verdades diferentes (onde estou × o que vale).

## Regras de feedback

1. **Imediato**: resposta visual/sonora no mesmo gesto (idealmente no mesmo frame da ação); ação lenta mostra progresso ou "recebido" na hora e o resultado quando vier.
2. **Localizado**: quem mudou, brilha — dano na barra que caiu, erro no campo que falhou, sucesso no item comprado. Feedback longe da causa obriga caça visual.
3. **Proporcional**: micro (hover, clique) em dezenas de ms; transição de tela curta e com direção (entrar/sair contam onde você está no mapa); comemoração só para conquista de verdade.
4. **Com fim**: animação decorativa termina ou entra em repouso discreto; HUD inteiro respirando/piscando compete com o mundo e cansa.
5. **Redundante sob pressão**: evento crítico soma canal (visual + som, ou visual + movimento) — nunca som sozinho, nunca cor sozinha.

## Som de UI

- Por hook/evento (confirmar, cancelar, erro, hover opcional), em barramento de UI próprio (`godot-audio-cinematics` cuida do mix); volume e mudo respeitam as configurações.
- Erro tem som **distinto** de confirmar; som igual para sucesso e falha treina o jogador a ignorar os dois.
- Nada de som em hover por padrão em menu de controle (foco se move em rajada) — som é de ação, não de passagem.

## Dados sem susto

- Contador e barra animam **para** o valor real; evento (número de dano, "+1") é instantâneo e some. Valor exibido nunca fica diferente do valor do sistema além da animação.
- HUD apresenta, não calcula regra: quem publica estado é o sistema (sinal/dado); UI formata, interpola e apresenta. Verificação de "pode comprar" mora no sistema — a UI só mostra o veredito.

## Erros clássicos

- Botão que não muda ao clicar e ação que leva 300 ms: clique duplo e compra dupla.
- Erro genérico ("algo deu errado") sem o que fazer agora.
- Animação de entrada de tela mais longa que a paciência de quem abre o menu 50 vezes.
- Sucesso comemorado igual para "item comum comprado" e "chefão morto".

---
_Orientação revisada em 2026-10-17 para Godot 4.7+. Tempo e exagero se calibram jogando com som, na velocidade real do jogo._
