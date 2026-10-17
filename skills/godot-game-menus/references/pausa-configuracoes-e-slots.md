# Pausa, configurações e slots

## Pausa (o menu que não pode quebrar o jogo)

- Pausa de verdade: a árvore pausa (`get_tree().paused`) e o menu vive **fora** dela (nó de pausa com `process_mode` sempre ativo); mundo congelado atrás, com a cena legível (escurecer/blur leve é apresentação, não pausa de mentira).
- Resumir devolve **exatamente**: mesmo estado, mesmo foco de gameplay, sem música duplicada nem timer reiniciado. Pausar durante cutscene/diálogo segue a regra desses sistemas (quem é o dono do tempo decide).
- Itens: Continuar (foco inicial — Enter apressado volta ao jogo, não sai dele), Configurações, Salvar (se o jogo salva manualmente), Tela de título e Sair, com sair **salvando ou perguntando** conforme o design do save. Nada destrutivo a um Enter de distância sem confirmação.
- Abrir/fechar pausa é instantâneo e reversível pelo mesmo botão (Esc/Start nos dois sentidos); pausa que só abre por um caminho e fecha por outro treina erro.

## Configurações (uma tela, dois donos)

- A mesma tela serve título e pausa: quem chama é dono da volta (pilha de navegação com foco restaurado). Categorias do pacote: Vídeo, Áudio, Controles (remapeamento com conflito tratado), Acessibilidade (escala de texto/UI, reduzir tremor/movimento/flash) e **Idioma (pt-BR/en no mínimo, `godot-localization`)**.
- **Aplicar e persistir**: muda na hora onde dá (volume, idioma, escala) e grava no arquivo de configurações do jogador; reiniciar o jogo prova que persistiu. "Restaurar padrões" existe e é reversível de achar.
- Slider/opção mostra o efeito ao mexer (volume toca som de teste discreto, escala mostra a UI mudar) — configuração cega se calibra por tentativa e erro fora do menu.
- Nada de configuração que exija reiniciar sem avisar **antes** de mudar (resolução legada e afins): avisar depois é armadilha.

## Slots e saves (decisão com metadado)

- Slot se escolhe por **metadado**: tempo de jogo, capítulo/área/fase, data/hora, dificuldade/modo e eventual captura. "Slot 1 — 12/03" sem contexto é adivinhação com o progresso alheio.
- Estados desenhados: vazio ("Novo jogo aqui"), ocupado, corrompido/incompatível (diz o que aconteceu e oferece criar por cima — nunca finge que carrega).
- Sobrescrever e excluir: confirmação com a consequência nomeada ("apaga Maria — Capítulo 3, 14 h"), botão destrutivo separado, foco inicial **longe** dele. Um save só (autosave) pede o mesmo cuidado na troca de "Novo Jogo" sobre ele.
- Carregar é pela skill de save do pacote (JSON validado); o menu só apresenta e pede — quem lê, valida e aplica é o sistema.

## Créditos e extras

- Créditos: rolagem pausável/acelerável, qualquer entrada sai (com a rolagem completa acessível sem pressa), nomes por função e licenças de assets/tools (CC-BY mora aqui — `godot-free-assets` gera os créditos).
- Extras (galeria, conquistas, jukebox) entram pela mesma pilha e tema; conteúdo trancado mostra condição, não mistério.

## Erros clássicos

- Pausa que não pausa o timer da fase nem o inimigo "porque é só um menu".
- Configuração que só vale até fechar o jogo.
- Slot focado em "Excluir" e Enter apagando 14 horas.
- Voltar das configurações para o lugar errado (pausa que volta ao título).

---
_Orientação criada em 2026-10-17 com base nas regras do pacote (UI/UX, save, localização). Persistência se prova reiniciando o build, não relendo o código._
