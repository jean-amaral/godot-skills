# Pesquisa e referências antes de construir

Regra do pacote: **nada visual ou de gameplay se constrói "de cabeça"**.
Cenário, mecânica, terreno, prop e material nascem de pesquisa com
referências — imagem, documentação e estudo de como a coisa real (ou a
referência de estilo) é feita. É isso que separa "parece um jogo" de
"parece o lugar/mecânica que o criador imaginou".

## O ciclo (sempre nesta ordem)

### 1. Perguntas antes de respostas

Escreva o que precisa descobrir, em perguntas respondíveis: "qual é a
proporção de uma porta industrial para a parede?", "como um galpão real
distribui colunas?", "o que faz essa mecânica ser satisfatória nos
primeiros 30 segundos?". Pergunta vaga gera referência vaga.

### 2. Fontes, por tipo de pergunta

| Pergunta | Fonte primária |
|---|---|
| Como a engine faz X? | Documentação oficial e API da versão do projeto (nunca tutorial de versão antiga sem conferir) |
| Como isso é no mundo real? | Foto de referência do objeto/lugar real (arquitetura, material, desgaste) |
| Como o estilo alvo resolve? | Obra de referência do estilo escolhido (jogo/filme do GDD), analisada — não copiada |
| Preciso do asset em si? | Skill `godot-free-assets` (CC0/CC-BY com crédito) — referência de estudo não é asset baixável |

Direito e procedência: imagem de referência é **estudo**. Não embuta,
redistribua nem trace por cima de imagem protegida no projeto; registre
URL, data de acesso e, quando a imagem for baixável e licenciada, a licença.
Textura/modelo que entra no jogo vem de fonte licenciada, não de screenshot.

### 3. Análise: transformar imagem em especificação

Preencha o painel ([../templates/painel-referencias.md](../templates/painel-referencias.md))
extraindo da referência o que se constrói:

- **Silhueta e proporção**: medidas relativas usando uma âncora conhecida
  (porta = 2,1 m, pessoa = 1,8 m) — é daqui que sai a tabela de dimensões.
- **Construção**: de que peças o todo é feito e como se repetem (o módulo!),
  onde vão trim, junta, reforço e borda.
- **Material e cor**: lista de materiais com paleta (hex aproximado),
  rugosidade aparente e onde o desgaste mora (canto, rodapé, ponto de contato).
- **Luz**: direção, dureza e temperatura da luz que vende a referência.
- **Gameplay (para mecânica)**: o loop de 30 segundos, a decisão que o
  jogador toma, o feedback que confirma — observados na referência, não inventados.

### 4. Especificação de construção

O painel termina em ordem de construção: peças modulares com dimensões,
materiais (com a textura-fonte quando houver), pivôs, colisores e o que
será CSG, prop ou terreno. Sem isso, a "inspiração" não virou projeto.

### 5. Construir e comparar

Construa, capture da **mesma posição de câmera** da referência principal
e compare lado a lado: proporção, silhueta, paleta, material, luz. Cada
diferença ou é corrigida ou é decisão registrada ("mudamos X porque Y").
É essa comparação — não a sensação de quem construiu — que aprova o trecho.

## Erros clássicos

- Pesquisar **depois** de construir, só para justificar o que já foi feito.
- Uma única imagem de referência para um ambiente inteiro.
- Copiar a referência em vez de extrair suas regras (proporção/material):
  cópia quebra no primeiro cômodo diferente; regra constrói o prédio todo.
- Tutorial como verdade: confira a API na versão do projeto antes de aplicar receita de vídeo/post.
- Referência sem registro: sem URL/data/painel, ninguém reproduz nem audita a decisão depois.

---
_Referência revisada em 2026-10-16 (Godot 4.7.2). A suíte `tests/` prova os scripts do pacote; as receitas daqui são orientação de uso, não comportamento testado. Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
