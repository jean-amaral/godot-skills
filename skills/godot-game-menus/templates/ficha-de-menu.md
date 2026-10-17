# Ficha de menu — <jogo>

## Mapa

- Fluxo: Boot → Título → Principal → (jogo) ⇄ Pausa. Título e principal são a mesma tela? <sim/não — por quê>
- Dono da navegação: pilha única com memória de foco. Tema: <o do projeto>

## Itens e estados

| Item | Quando aparece | Foco inicial? | Confirmação |
|---|---|---|---|
| Continuar | só com save válido | sim, com save | — |
| Novo Jogo | sempre | sim, sem save | sobrescrever: <...> |
| <...> | | | |

## Entradas e idioma

- [ ] Controle / teclado / mouse navegam tudo; foco inicial definido por estado (com/sem save)
- [ ] Glifos do dispositivo atual; idioma pt-BR/en troca com o menu aberto

## Configuração e persistência

- [ ] Categorias: Vídeo · Áudio · Controles · Acessibilidade · Idioma
- [ ] Persiste ao reiniciar (provado no build); "restaurar padrões" existe

## Verificação

- [ ] Boot → primeiro item em segundos, splash pulável
- [ ] Pausar/resumir idênticos; sair salva ou pergunta
- [ ] Pseudolocalização e resoluções sem quebra
- [ ] Referência de menu do gênero comparada: <qual, o que foi extraído>
