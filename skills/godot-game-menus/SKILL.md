---
name: godot-game-menus
description: Criação de menus de jogo na Godot — tela de título, menu principal, pausa, configurações, seleção de save/slots, créditos e extras — sobre o sistema de Control/Theme da engine, com fluxo de boot, navegação por controle/teclado/mouse, estados de save e transições de cena. Use quando o criador pedir menu de título, menu principal, tela inicial, menu de pausa, configurações ou qualquer menu de sistema do jogo.
---

# Godot Game Menus

Menu é a capa e a recepção do jogo: **a primeira tela vende o mundo, e cada menu de sistema respeita o tempo do jogador**. Título bonito que não se navega de controle é bug; configuração que não persiste é mentira.

Esta skill é a especialização de menus da `godot-ui-ux` (hierarquia, layout, acessibilidade e testes vivem lá — leia-a junto). Na Godot, menu é **Control + Theme em CanvasLayer/cena própria**; não há outro framework de UI no pacote. Texto sempre por chave (`godot-localization`, pt-BR + en), som de UI pela `godot-audio-cinematics`, câmera de fundo pela `godot-phantom-camera` quando o fundo é cena do jogo.

## Pesquisa sempre (regra do pacote)

Antes de desenhar qualquer menu, pesquise referências atuais — menus de jogos do gênero (imagem e vídeo, navegando de verdade), a documentação oficial da versão e o que a `godot-ui-ux` prescreve — e transforme em especificação (itens, ordem, hierarquia, estados) antes de abrir o editor. Método completo: `agent-frontier-reasoning`. Primeira ideia é rascunho; menu aprovado é o comparado com a referência e testado de controle na mão.

## O mapa de menus (desenhe antes das telas)

```
Boot/Splash (curto, pulável) → Título ("pressione para começar" + logo/versão)
  → Principal: [Continuar*] [Novo Jogo] [Carregar] [Configurações] [Créditos/Extras] [Sair†]
      Novo Jogo → slots (ou confirmação de sobrescrever) → (jogo)
      Configurações → Vídeo · Áudio · Controles · Acessibilidade · Idioma (pt-BR/en)
  (no jogo) Pausa: [Continuar] [Configurações] [Salvar*] [Título] [Sair†]
      * só quando faz sentido existir · † só onde a plataforma tem "sair" (desktop)
```

- Título e principal podem ser **a mesma tela** em jogo pequeno (logo + itens direto) — decidir pelo tamanho do jogo, não por costume. O que não pode: boot com três logos não puláveis antes do primeiro item clicável.
- Ordem dos itens é leitura de intenção: continuar o progresso vem antes de começar do zero **quando há save**; sem save, Novo Jogo é o primeiro e Continuar nem aparece (item morto desabilitado na primeira tela ensina o jogador a ignorar o menu).

## Padrões por menu

### Título e principal

- O fundo é o jogo se apresentando: cena viva, arte-chave ou câmera lenta do mundo (atract mode quando couber) — fundo genérico desfaz em 3 segundos a promessa da capa. Movimento respeita "reduzir movimento" (`godot-ui-ux`).
- Logo legível em silhueta pequena, versão do build visível e discreta (é ela que o jogador cita no bug), e "pressione para começar" aceitando **o dispositivo que ele está usando** (qualquer entrada vale, inclusive clique/toque).
- Música/som começam **depois da primeira interação** em web (política de autoplay) e sem estouro de volume em qualquer plataforma: menu abre no volume salvo.
- Foco inicial no item certo (Continuar com save, Novo Jogo sem), navegável inteiro sem mouse, com som de confirmação/cancelamento distintos — detalhe e orçamento em [references/titulo-e-principal.md](references/titulo-e-principal.md).

### Pausa e sistema

- Pausa **pausa de verdade** (`process_mode`/árvore pausada com o menu fora da pausa), resume no mesmo estado, e sair para o título salva ou pergunta — nunca descarta progresso em silêncio.
- Configurações aplicam e **persistem** (mesmo arquivo de settings do pacote, idioma incluso) e sobrevivem a reiniciar o jogo; voltar restaura foco e posição de onde chamou (jogo × título têm donos diferentes para a mesma tela de configurações).
- Slots mostram o que decide (tempo de jogo, capítulo/área, data, dificuldade), com estados vazio/erro projetados e exclusão como ação destrutiva confirmada e **nunca** focada por padrão.
- Créditos rolam/param com qualquer entrada e voltam ao chamador; extras/gallery seguem o mesmo navegador de telas, sem sistema paralelo.

Detalhe de pausa/configurações/slots em [references/pausa-configuracoes-e-slots.md](references/pausa-configuracoes-e-slots.md).

### Arquitetura (Godot)

- Um **navegador de telas** só: pilha abrir/voltar com memória de foco, cada tela uma cena/Control sob o mesmo `Theme`. Menu não decide gameplay: emite intenção (novo jogo, carregar slot N, sair) para quem manda no jogo executar.
- Transição título → jogo usa a troca de cena do pacote (carregamento assíncrono quando a cena pesa, com tela de loading honesta); menu por cima do jogo é `CanvasLayer` acima do mundo e abaixo de diálogos de sistema.
- Cena de menu reutiliza o mundo como fundo quando barato (câmera própria/Phantom), sem carregar o jogo inteiro só para enfeitar — custo de abrir o menu também se mede (`godot-performance-testing`).

## Verificação (controle na mão, sempre)

- [ ] Boot → primeiro item acionável em segundos, tudo pulável.
- [ ] Menu inteiro só de controle, só de teclado e só de mouse, sem foco perdido nem preso.
- [ ] Com save: Continuar primeiro e funcionando; sem save: ele nem aparece.
- [ ] Sobrescrever/excluir pedem confirmação e não são o foco inicial.
- [ ] Configuração muda, persiste ao reiniciar e o idioma troca **no menu aberto** (pt-BR ↔ en).
- [ ] Pausar e resumir devolvem o jogo idêntico; sair salva ou pergunta.
- [ ] Resoluções mínima/alvo/ultrawide e pseudolocalização sem quebra (`godot-ui-ux`/`godot-localization`).

## Arquivos desta skill

| Arquivo | Conteúdo |
|---|---|
| [references/titulo-e-principal.md](references/titulo-e-principal.md) | Boot/splash, título, principal, fundo vivo, itens e foco |
| [references/pausa-configuracoes-e-slots.md](references/pausa-configuracoes-e-slots.md) | Pausa, configurações persistentes, slots de save, créditos e extras |
| [templates/ficha-de-menu.md](templates/ficha-de-menu.md) | Ficha de menu: mapa, itens/estados, entradas e verificação |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de mudanças da skill |
