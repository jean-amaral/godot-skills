# Fluxos, menus e onboarding

Menu é um caminho com propósito, não uma pilha de telas. Desenhe o caminho antes das telas.

## Mapa de telas (antes de qualquer cena)

Para cada tela, registre no brief: **intenção** (uma frase), **entrada** (de onde vem), **ação primária**, **saída/cancelar** e **estado ao voltar** (o que a tela anterior lembra: foco, rolagem, seleção).

```
[Início] --Novo jogo--> [Confirmar slot] --Começar--> (jogo)
    |                         ^ Esc/B sempre volta um nível, nunca fecha o jogo sem querer
    +--Continuar--> (jogo)    +--Configurações--> [Vídeo|Áudio|Controles|Acessibilidade]
```

- Profundidade cobrada em ações: tarefa frequente a no máximo 2 ações de onde o jogador está; esconder "Continuar" atrás de sub-menu é atrito sem função.
- Voltar é ação de primeira classe: mesmo botão/posição sempre, foco restaura onde estava, nada se perde ao cancelar (configuração só aplica ao confirmar, ou aplica ao vivo **com** desfazer óbvio).

## Os quatro estados de toda tela

| Estado | Pergunta de design |
|---|---|
| Normal | Qual é a ação primária e ela está óbvia em 3 segundos? |
| Vazio | Sem save/itens/amigos: a tela ensina o próximo passo ou é um beco? |
| Carregando | O que bloqueia, o que continua vivo, como cancela? |
| Erro | O que falhou, o que o jogador pode fazer agora, o que **não** se perdeu? |

Erro sem saída e vazio sem próximo passo são os dois becos clássicos de UX de jogo.

## Confirmação proporcional ao dano

- Reversível e barato (trocar aba): sem confirmação.
- Reversível com custo (gastar recurso comum): feedback forte, sem modal.
- Irreversível (apagar save, gastar recurso raro): confirmação com a consequência escrita ("apaga o slot 2, 14 h de jogo"), botão destrutivo separado e nunca como padrão focado.

## Onboarding e tutorial

1. **Uma ideia por vez, na hora em que ela serve**: ensinar cura quando a vida cai, não num texto de abertura com seis sistemas.
2. **Fazer > mostrar > ler**: peça a ação ("segure para mirar"), confirme o sucesso e siga; painel de texto é o último recurso.
3. **Progressivo e dispensável**: quem já sabe pula; quem falhou 2–3 vezes recebe a dica maior (ajuda adaptativa), não na primeira tentativa.
4. **Não bloqueie o mundo pelo ensino**: tutorial que trava câmera/controle ensina o menu, não o jogo — e é onde o jogador abandona.
5. Primeira sessão tem meta curta e vitória garantida: o jogador termina sabendo o loop de 30 segundos do jogo e querendo repetir.

## Erros clássicos

- Tutorial front-loaded (tudo antes de jogar) e tutorial que some para sempre depois de fechado sem querer (dica mora também no menu/codex).
- Configuração que exige reiniciar sem dizer antes de mudar.
- "Pressione qualquer tecla" que não aceita o controle que o jogador está segurando.

---
_Orientação de design revisada em 2026-10-17 para Godot 4.7+. Fluxo se valida contando ações e observando gente jogando, não relendo o mapa._
