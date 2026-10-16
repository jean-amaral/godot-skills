# UI de jogo (HUD, menus e texto)

UI de jogo 3D continua sendo `Control`: HUD por âncoras/containers, mundo 3D por nós — não misture os dois sistemas de layout.

## Layout que sobrevive a resolução

- Monte com containers (`VBox/HBox/Grid/Margin`) e âncoras; posição absoluta só para elemento livre de HUD (dano flutuante, marcador).
- Teste em três tamanhos: menor suportado, alvo e ultrawide. Quebra de layout aparece primeiro no menor.
- Escala de UI é configuração do jogador (fator sobre o tema), não zoom de viewport improvisado.
- Preview 3D dentro de menu (personagem/item girando) é `SubViewport` com mundo próprio e câmera dedicada, com taxa de atualização reduzida — nunca a câmera do jogo emprestada.

## Listas grandes

- Inventário/loja com centenas de itens pede reutilização de células (pooling de itens de lista): instanciar um `Control` por item é o gargalo clássico de menu.
- Atualize por diferença (o que mudou), não reconstruindo a lista a cada abertura.

## Tema e acessibilidade em runtime

- Um `Theme` do projeto com variações nomeadas; troca de tema/tamanho em runtime reaplica sem reiniciar a cena.
- Foco navegável por teclado/controle em todo menu (ordem de foco testada com o controle, não só com o mouse) e vizinho de foco explícito onde o container não acerta sozinho.
- Contraste e tamanho mínimo de texto são orçamento de acessibilidade, definidos no tema — não por tela.
- Texto de jogo passa por localização desde o primeiro menu: chave, não frase solta no nó. Termos da engine ficam em inglês; texto do jogador, no idioma do projeto.

## RichText com segurança

- BBCode de fonte confiável (seus dados) pode ir direto; texto que o jogador digita ou que vem de arquivo externo passa por sanitização (escape de tags) antes de entrar no `RichTextLabel` — tag não escapada quebra o layout e pode travar o parser em entrada patológica.
- Efeito de máquina de escrever (typewriter) revela por caractere sobre o texto já formatado, pausando em pontuação; pular diálogo completa a frase primeiro, avança no segundo toque.
- Efeitos customizados (`RichTextEffect`) são enfeite posterior: o texto precisa ser legível com o efeito desligado.

---
_Referência revisada em 2026-10-16 (Godot 4.7.2). A suíte `tests/` prova os scripts do pacote; as receitas daqui são orientação de uso, não comportamento testado. Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
