# Pesquisa na internet antes de criar

Regra do pacote: **criação não trivial começa com pesquisa**. Pesquisar não é confirmar o que você já faria — é descobrir o que você não sabe antes que vire retrabalho.

## O que pesquisar (perguntas primeiro)

Escreva as perguntas respondíveis antes de abrir o navegador:

- Como a ferramenta/engine faz X **nesta versão**? (documentação oficial)
- Como isso é no mundo real / no estado da arte do gênero? (referência)
- Quem já errou nisto e qual é a armadilha catalogada? (issue, post-mortem, discussão técnica)
- Existe solução pronta e licenciada? (no pacote: skill `godot-free-assets`, só CC0/CC-BY)

Pergunta vaga ("melhor HUD") gera resultado vago. Pergunta boa tem objeto, contexto e restrição ("HUD de vida legível em combate rápido, Godot Control, controle e TV").

## Hierarquia de fontes

1. **Documentação oficial e código-fonte** da versão em uso — decide fato de API/comportamento.
2. **Fonte primária do domínio**: o jogo/filme/objeto real analisado, paper, especificação, mantenedor explicando.
3. **Comunidade técnica com evidência**: issue com reprodução, resposta com código testado, análise com capturas/dados.
4. **Tutorial/blog/vídeo**: serve como mapa e hipótese — **nunca** como prova. Confira a afirmação na fonte de nível 1–2 antes de construir sobre ela.

Resumo de IA, snippet de busca e resposta agregada são **índice**, não fonte: abra a página, leia o trecho, confira data e versão.

## Verificação cruzada

- Fato que sustenta decisão importante precisa de **duas evidências independentes** (doc + comportamento observado, ou duas fontes primárias que não se copiam).
- Desconfie de página sem data ensinando ferramenta versionada; de "sempre/nunca" sem contexto; de solução com cara de gerada que não compila na sua versão.
- Quando fontes divergem, a **oficial da sua versão** e o **teste local** vencem — nessa ordem de desempate: teste local prova o seu caso.

## Registrar (para o criador poder cobrar depois)

Para cada descoberta que mudou o plano, anote: pergunta, fonte (URL), data de acesso, o que ela sustenta e o que você decidiu com isso. No pacote Godot, o painel de referências (`godot-3d-specialist/templates/painel-referencias.md`) é esse registro no domínio visual/gameplay; em texto/plano, o [canvas de tarefa](../templates/canvas-de-tarefa.md) cumpre o papel.

Referência é **estudo**: não copie arte, texto ou asset protegido para dentro do projeto. Asset que entra no jogo vem de fonte licenciada, com crédito.

## Sem internet (degradar com honestidade)

1. Diga que está sem acesso e o que isso afeta.
2. Use documentação/arquivos locais e marque as afirmações dependentes como **não verificadas**.
3. Prefira decisões reversíveis nas partes não verificadas e deixe o teste local decidir.
4. Nunca escreva "segundo a documentação" sem tê-la aberto.

## Erros clássicos

- Pesquisar **depois** de construir, para enfeitar a justificativa.
- Abrir três páginas que copiam a mesma fonte e chamar de consenso.
- Tutorial de versão antiga aplicado sem conferir a API atual.
- Parar no primeiro resultado que concorda (pesquisa-confirmação).

---
_Referência criada em 2026-10-17. Pesquisa boa é a que muda uma decisão antes do custo — e deixa rastro para ser auditada._
