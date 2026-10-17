# Revisão adversarial e entrega calibrada

A última passada não é reler com carinho: é **tentar derrubar** o que você fez, do jeito que um revisor forte faria — antes do criador (ou do jogador) fazer isso por você.

## A passada do adversário (nesta ordem)

### 1. O óbvio em 30 segundos

O que salta aos olhos de quem é bom e chega agora? Nome errado, proporção errada, estado faltando, texto confuso, arquivo no lugar errado. Se o adversário acha em 30 s, a sua entrega não teve segunda leitura.

### 2. Casos que quebram

- Entrada vazia, nula, gigante, malformada, no idioma mais longo, com caractere especial;
- Estado intermediário: meio-salvo, meio-carregado, cancelado no meio, duas vezes seguidas (duplo clique, reabrir, repetir);
- Ordem trocada: usar antes de existir, sair antes de terminar, voltar para onde não lembra de você;
- Ambiente adverso: resolução menor/maior, sem internet, permissão negada, versão anterior;
- O usuário **errado com confiança**: quem faz o uso plausível que você não desenhou.

Cada quebra achada: corrigir, proteger ou declarar como limitação consciente. Esconder não é opção.

### 3. Afirmações sob evidência

Liste o que a entrega afirma ("funciona", "é rápido", "segue o padrão") e pergunte, uma a uma: **qual verificação prova?** Afirmação sem prova vira suposição declarada ou sai da entrega.

Verificação que vale:

- Rodou e observou (teste, build, captura, saída real citada);
- Comparou com referência/fonte (lado a lado, não de memória);
- Releu contra a especificação/critério de aceite, item a item.

Não vale: "o código parece certo", "o teste que eu escrevi sobre a minha suposição passou", "da outra vez funcionou".

### 4. O que o domínio cobra

Rode a verificação que **a skill de domínio** manda para aquilo (auditoria, suíte, checklist da disciplina). Revisão genérica não substitui a específica — ela vem antes, para você não entregar o que a específica reprovaria.

## Calibrar a entrega

- **Pronto**: verificado pela via real, limites declarados. Diga como verificou.
- **Pronto com ressalvas**: funciona no caminho provado; liste exatamente o não verificado e o risco dele.
- **Não pronto**: diga o que falta e qual é o próximo passo — sem embrulhar em otimismo.

Proibido: inflar ("arquitetura robusta e escalável" para 80 linhas), esconder falha conhecida no meio de texto bonito, prometer verificação futura como se fosse resultado.

## Pergunta final (antes de enviar)

> Se um modelo de fronteira recebesse esta entrega para revisar, qual seria a **primeira** crítica dele — e eu já tenho a resposta?

Se a crítica não tem resposta, a entrega não acabou: corrija ou declare.

---
_Referência criada em 2026-10-17. Revisão boa é a que encontra o problema enquanto ele ainda é barato._
