---
name: godot-multiplayer-2d
description: Multiplayer 2D na Godot 4.7+ sobre o núcleo godot-multiplayer — sincronizar CharacterBody2D de plataforma/top-down, estado de TileMap e salas, interpolação de sprites remotos, autoridade de dano e câmeras 2D por jogador (incl. tela dividida). Use quando o jogo 2D (co-op ou competitivo) precisar de jogadores/inimigos/mundo sincronizados em rede.
---

# Godot Multiplayer 2D

O contrato de rede (autoridade, RPC, spawn, segurança, sessão) é da skill-mãe `godot-multiplayer` — **leia-a primeiro**. Esta skill é o que muda no 2D: movimento preciso em tiles, sprite que não pode tremer e mundo em grade.

Base 2D: `godot-2d-specialist`. Arte/animação: `godot-2d-visual-craft`. Câmera: `Camera2D` nativa ou Phantom Camera 2D (`godot-phantom-camera`).

## Pesquisa sempre (regra do pacote)

Antes de criar ou alterar qualquer coisa nesta disciplina, **pesquise informações e referências atuais**: documentação oficial da versão do projeto, referências de imagem/vídeo/texto e como quem é bom resolve o mesmo problema — e transforme a pesquisa em especificação antes de executar. Primeira ideia é rascunho, nunca entrega. Método completo (perguntas, fontes, verificação cruzada e registro): skill `agent-frontier-reasoning`. Sem internet, declare explicitamente o que ficou não verificado e baixe a confiança do afetado.

## O que sincroniza em 2D (e como)

| Coisa | Desenho |
|---|---|
| Avatar (plataforma/top-down) | Spawn pelo servidor; autoridade = dono. Posição sincronizada em intervalo curto e **interpolada** nos remotos — sprite que teleporta a cada pacote é o defeito visual nº 1 do 2D em rede |
| Estado de movimento | Dado pequeno sincronizado (estado, direção, velocidade) para a animação remota — nunca a animação decidindo |
| Tile/mundo alterável (quebrar bloco, porta, baú) | Evento confiável da autoridade + estado: quem entra depois recebe o estado atual, não o histórico de eventos |
| Dano/coleta | Autoridade valida e concede (hitbox local propõe, servidor dispõe quando importa) |
| Inimigo de plataforma simples | Autoridade do servidor; patrulha/perseguição simulados só lá, remoto apresenta |

## Movimento, física e o pixel

- Plataforma é precisão: pulo tem janela de tiles (ficha da `godot-2d-specialist`). Remoto interpolado não pode "comer" a borda da plataforma visualmente — apresente o remoto com o corpo **sem colisão decisiva** e deixe a autoridade arbitrar contato; o dono local nunca é corrigido com teleporte seco em co-op confiável (correção visível = controle quebrado na mão do jogador).
- Pixel art em rede: posição apresentada interpolada conflita com snap de pixel (a `godot-2d-visual-craft` manda snap para não nadar). Remoto interpolado com snap ligado **anda em degraus** — decida por jogo: snap só no avatar local e interpolação livre (sub-pixel) nos remotos é o compromisso comum, registrado na ficha visual.
- Top-down: direção/diagonal e mira sincronizam como dados pequenos e frequentes; projétil rápido é da autoridade (spawn sincronizado), cliente prevê o visual sem decidir acerto.
- `TileMapLayer` não sincroniza célula a célula sozinho: mudança de tile é evento da autoridade aplicado igual em todos (`set_cell` via RPC confiável/spawn de estado), e o estado inicial de quem entra tarde é enviado como **conjunto de células alteradas**, não confiando que ele "nasceu com o mesmo mapa editado".

## Câmera 2D por jogador e tela dividida

- Cada processo tem sua `Camera2D` seguindo o **seu** avatar com os limites do nível; Phantom 2D (Framed/Simple) funciona igual, um Host por máquina.
- Co-op no mesmo mapa com câmeras livres exige decidir: câmeras independentes (cada um vê o seu), câmera de grupo (enquadra todos, limita a distância entre jogadores — tether) ou split-screen (Viewports). São três jogos diferentes em leitura: escolha no design (experiência em `godot-ui-ux`), não na implementação.
- Split-screen: cada Viewport com seu mundo/câmera e seu jogador; sincronização continua sendo a mesma rede — viewport não é atalho de autoridade.

## Testes específicos 2D

- [ ] Remoto andando/pulando sem tremer nem degrau de pixel inaceitável (decisão registrada).
- [ ] Vão/plataforma no limite da ficha: igual nas duas telas.
- [ ] Tile alterado (bloco quebrado/porta) igual para quem estava e para quem entrou depois.
- [ ] Coleta/dano simultâneos no mesmo item: um só ganha, decidido pela autoridade.
- [ ] Câmera(s) corretas após morte/respawn de cada jogador.

## Arquivos desta skill

| Arquivo | Conteúdo |
|---|---|
| [references/sincronizacao-2d.md](references/sincronizacao-2d.md) | Interpolação × snap de pixel, estado de TileMap, co-op de câmera e inimigos simples |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de mudanças da skill |
