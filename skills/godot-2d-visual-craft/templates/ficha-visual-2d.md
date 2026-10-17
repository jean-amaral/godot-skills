# Ficha visual 2D — <jogo/bioma>

## Mundo visual

- Estilo: <pixel art / pintado HD / outro> — resolução-base: <px> — escala-alvo: <inteira ×N / livre>
- Grade: tile <px> · personagem <px / em tiles>
- Importação: filtro <nearest/linear> · snap de pixel <sim/não> — conferido em jogo: [ ]

## Paleta (por ambiente)

- Ambiente <nome>: <hex...> — fundo × terreno × perigo × personagem: como se distinguem?

## Personagem e animações (da ficha de movimento)

| Estado | Animação | Frames/FPS | Poses-chave | Marco (som/passo/efeito) |
|---|---|---|---|---|
| <idle/run/jump...> | | | | |

## Tileset e fundo

- Famílias: <...> — peças de borda/quina conferidas montando 3 salas: [ ]
- Camadas/parallax (fator por camada): <...>

## Luz e efeitos

- Rig de clima: `CanvasModulate` <cor> · luzes <...> · oclusores onde: <...>
- Efeitos shader: <flash/outline/...> — informação redundante sem o efeito: <...>

## Verificação

- [ ] Captura em movimento: personagem/perigo/caminho legíveis
- [ ] Comparação com a referência: <diferença corrigida ou decisão>
