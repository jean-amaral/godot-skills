# Estratégias de pensamento

Ferramenta se escolhe pelo problema, não por hábito. Cada estratégia abaixo: quando usar, como fazer em minutos e o erro de uso.

## Decomposição (quase sempre, primeiro)

- **Quando**: qualquer tarefa que não cabe numa frase.
- **Como**: quebre em sub-resultados independentes, cada um com seu "pronto é...". O que depende de quê? O que pode ser provado isolado?
- **Erro**: decompor em tarefas ("editar arquivo X") em vez de resultados ("o jogador lê a vida sem procurar"). Tarefa sem critério vira movimento sem progresso.

## Primeiros princípios

- **Quando**: a solução óbvia é herança ("sempre fizemos assim") ou está cara/complexa demais.
- **Como**: liste o que é fisicamente/logicamente necessário (o jogador precisa saber X em Y ms; a engine só oferece Z) e reconstrua daí, ignorando como os outros empacotam.
- **Erro**: usar como desculpa para ignorar convenção que existe por razão (padrão da engine, do projeto). Reconstruir o necessário, respeitar o comprovado.

## Inversão e pré-mortem

- **Quando**: antes de executar plano com custo ou difícil de reverter.
- **Como**: "isto falhou feio — por quê?" Escreva 3–5 causas prováveis e transforme cada uma em prevenção ou teste cedo. Também: "o que eu faria se quisesse o resultado **oposto**?" revela o caminho certo por contraste.
- **Erro**: pré-mortem genérico ("pode dar erro"). Causa útil é específica e testável: "a API X não existe na 4.3" vira checagem de 1 minuto.

## Gerar alternativas de verdade

- **Quando**: qualquer decisão com mais de um caminho defensável.
- **Como**: force três famílias distintas — a direta, a mínima ("menos que resolve") e a estrutural ("resolve a classe do problema"). Compare por critérios escritos **antes** de olhar qual você prefere.
- **Erro**: espantalho — alternativas fracas de propósito para a favorita vencer. Se a sua preferida não sobrevive a alternativas honestas, ela não era a melhor.

## Segunda ordem e custo de oportunidade

- **Quando**: decisão que cria precedente, dependência ou manutenção.
- **Como**: "e depois disso, o quê?" — quem mantém, o que isso impede, o que fica mais difícil. Some o que você **deixa de fazer** ao escolher isto.
- **Erro**: só contar o custo de construção e ignorar o de viver com a coisa.

## Pensar pelo teste (falsificação)

- **Quando**: sempre que afirmar "isto funciona / é melhor".
- **Como**: antes de construir, escreva o que observaria se estivesse **errado** e qual é a verificação mais barata que mostraria isso. Construa nessa direção.
- **Erro**: teste que só pode passar (reler o próprio código, rodar o próprio exemplo feliz). Verificação boa tem como falhar.

## Analogia com disciplina

- **Quando**: domínio novo para você, domínio vizinho maduro.
- **Como**: importe a **estrutura** de quem resolve bem (como jogos do gênero apresentam vida; como editores profissionais confirmam ação destrutiva) e traduza as diferenças — nunca copie a superfície sem a razão.
- **Erro**: analogia pela aparência. O que transfere é a relação entre as partes, não o visual.

## Atualizar com evidência (bayesiano prático)

- **Quando**: pesquisa ou teste contradiz o plano no meio do caminho.
- **Como**: mude de ideia **em voz alta e registrado**: "eu achava X; a fonte/teste mostra Y; o plano muda em Z". Teimosia silenciosa e troca silenciosa são igualmente ruins.
- **Erro**: defender a primeira versão porque já foi escrita. Custo afundado não é argumento.

---
_Referência criada em 2026-10-17. Estratégia boa termina em decisão, teste ou pergunta melhor — nunca em texto bonito sobre pensar._
