# Entrevista de concepção: do sonho ao conceito jogável

Use quando o criador ainda não tem o conceito fechado — ideia vaga, gênero
sem mecânica, ou "quero algo diferente" sem saber o quê. Se o conceito já
está decidido, pule para o [planejamento](planejamento.md) e o GDD.

## Contrato da entrevista

1. **Uma pergunta decisiva por vez**, com a resposta recomendada e o porquê
   apresentados antes. O criador escolhe, altera ou discute — nunca é menu
   de múltipla escolha fria nem interrogatório em rajada.
2. **Não pergunte o que dá para descobrir**: leia antes o que já existe
   (documentos do projeto, protótipos, respostas anteriores). Pergunta é
   para julgamento e gosto, não para fato recuperável.
3. **Decisão tomada se escreve na hora**, no registro da entrevista
   ([../templates/entrevista-concepcao.md](../templates/entrevista-concepcao.md)),
   marcada como **Rascunho**. Só vira **Final** com aceite explícito do criador.
4. Ideia nova não invalida decisão anterior em silêncio: volte, registre a
   troca e o motivo. O histórico de decisões é o que permite confiar no conceito.
5. A entrevista termina em contrato, não em "acho que é isso": conceito em
   uma frase, pilares, não-objetivos, restrições, riscos e como validar.

## Fase 1 — Sonho e referências

Objetivo: a matéria-prima emocional, antes de qualquer mecânica.

- "Qual é o momento que você imagina o jogador vivendo?" (cena, não sistema)
- "Que jogos/filmes/lugares você quer **parecer** — e o que exatamente neles?"
- "O que você quer passar longe?" (anti-referências valem tanto quanto as outras)
- "Se só pudesse ficar uma sensação, qual seria?"

Registre referências com o **motivo** ("a tensão de X", não "parecido com X").

Decisão de estilo (obrigatória nesta fase, uma pergunta): **a recomendação
padrão deste pacote é construção modular realista** — proporções e materiais
do mundo real, o mais fiel que o projeto permitir. Pergunte: "seguimos
realista (recomendado) ou outro estilo — estilizado, toon, low-poly, retro?"
A resposta vira contrato: vale para props, materiais, iluminação e assets
externos, e entra no GDD. Sem resposta, assume-se realista e registra-se
a suposição.

## Fase 2 — Jogador e fantasia

- Quem joga, onde e por quanto tempo por sessão?
- Qual é o **verbo central** na cabeça do jogador (explorar, construir,
  enganar, sobreviver, colecionar)? Um verbo; o segundo é suporte.
- O que o jogador faz de interessante nos primeiros 10 minutos?
- O que ele conta para um amigo depois de jogar? Essa frase é o teste da fantasia.

## Fase 3 — Restrições (a inovação mora aqui)

Restrição não é inimiga da ideia; é o que a força a ser nova. Feche cedo:

- Plataforma e entrada (teclado/controle/toque), sozinho ou acompanhado.
- Tamanho real da equipe e prazo honesto, não o desejado.
- Ferramentas e limites técnicos assumidos (para este pacote: Godot 3D).
- Conteúdo fora de questão (violência, temas, monetização).

Para cada restrição dura, pergunte: "o que essa restrição **permite** que
um jogo sem ela não faria?" É dessa resposta que sai o diferencial.

## Fase 4 — Geração de ideias (sem julgar)

Gere de 5 a 10 conceitos de uma frase cada, combinando sonho × verbo ×
restrição. Técnicas, uma rodada por técnica:

- **Combinação improvável**: a mecânica de um gênero dentro da fantasia de outro.
- **Inversão**: quem caça vira caça; perder vira progredir; o "inimigo" ajuda.
- **Remoção do óbvio**: tire o elemento que todo jogo do gênero tem (inventário, vida, pulo) e veja o que nasce no lugar.
- **Troca de escala ou perspectiva**: o mapa vira personagem; você é o terreno; um botão só.
- **O mundo reage**: "e se o cenário respondesse a [verbo central]?" — em 3D, espaço que reage é a alavanca mais barata de novidade.
- **Restrição extrema temporária**: projete por 5 minutos como se só houvesse um botão, uma cor ou um cômodo.

Nesta fase é proibido "isso não funciona": viabilidade é a próxima fase.

## Fase 5 — Funil de seleção

Pontue cada conceito (1–3) nos mesmos critérios e mate sem dó:

| Critério | Pergunta |
|---|---|
| Fantasia | Entrega a sensação da Fase 1/2 em uma frase? |
| Novidade | O que ele faz que a referência não faz? |
| Protótipo | Dá para testar a graça em um protótipo de 10 minutos? |
| Escopo | Cabe nas restrições da Fase 3 sem heroísmo? |
| Risco | Qual é a maior incógnita — e ela é testável cedo? |

Sobrevive quem tem novidade **testável barato**. Conceito cuja graça só
aparece "no jogo completo" é risco disfarçado de visão.

## Fase 6 — Conceito final e validação

Feche o contrato e despeje no GDD ([../templates/gdd.md](../templates/gdd.md)):

- Conceito em uma frase (fantasia + verbo + diferencial).
- Até 3 pilares, cada um com o que ele **proíbe** (pilar sem veto é enfeite).
- Não-objetivos explícitos (o que este jogo recusa ser).
- **Hipótese de inovação**: "acreditamos que [diferencial] causa [sensação];
  saberemos se for falso quando [sinal observável no protótipo]".
- Menor protótipo que pode falsificar a hipótese — esse é o primeiro
  entregável da Fase 2 do [planejamento](planejamento.md) (greyboxing).

## Erros clássicos

- Entrevistar com formulário: 20 perguntas de uma vez geram 20 respostas rasas.
- Pular as restrições e "sonhar livre": o conceito nasce impossível e morre no escopo.
- Confundir tema com mecânica: "jogo de pirata" não é conceito; "roubar navios **sem poder lutar**" começa a ser.
- Aceitar o primeiro conceito por cansaço da entrevista: a Fase 4 existe para haver comparação.
- Não escrever: decisão só falada se perde e volta como discussão repetida.

---
_Referência revisada em 2026-10-16 (Godot 4.7.2). A suíte `tests/` prova os scripts do pacote; as receitas daqui são orientação de uso, não comportamento testado. Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
