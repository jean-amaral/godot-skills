# Título e menu principal

## Boot e splash

- Splash é identidade, não espera: logos curtos, **puláveis com qualquer entrada** e somados em segundos, não em dezenas. Quem já viu uma vez não paga de novo igual (versão curta em boots seguintes é cortesia clássica).
- Carregamento de verdade (primeira cena pesada) acontece aqui ou atrás do título, com progresso honesto quando demora — nunca atrás de splash falso que já acabou e finge carregar.

## A tela de título

- Três camadas, nesta hierarquia: **logo** (o nome como imagem/silhueta, legível pequeno), **convite** ("pressione para começar" ou os itens direto) e **mundo** (o fundo). Se o olho não sabe para onde ir primeiro, a hierarquia falhou.
- Fundo vivo com disciplina: cena do jogo em câmera lenta (Phantom com PCam de menu), arte-chave animada de leve ou partículas — parado demais parece jogo quebrado, agitado demais compete com o logo. Demonstração automática (attract) só entra após inatividade longa e sai com qualquer entrada.
- Versão do build (`v1.0.3`) e direitos num canto discreto: suporte e bug report começam por essa string.
- Som: silêncio ou ambiente até a primeira interação (obrigatório na web), então a música do menu entra no volume salvo das configurações — nunca em volume fixo "de fábrica" por cima da preferência.

## O menu principal

| Item | Regra |
|---|---|
| Continuar | Só existe com save válido; é o primeiro e o foco inicial nesse caso; um toque até estar jogando |
| Novo Jogo | Sem save: primeiro item. Com save: leva a slots ou pede confirmação de sobrescrever **antes** de qualquer criação |
| Carregar | Lista de slots com metadados que decidem (tempo, capítulo, data); slot vazio é estado desenhado, não erro |
| Configurações | Abre por cima (pilha), volta para **este** menu com foco restaurado |
| Créditos/Extras | Quando existem; créditos voltam com qualquer entrada |
| Sair | Só onde a plataforma tem sair (desktop); no web/mobile o item nem nasce. Confirmar só se houver progresso não salvo em jogo — no título, sair é livre |

- Itens que o jogo não tem (multiplayer num jogo solo, extras trancados) **não aparecem** — item permanentemente desabilitado no principal é promessa quebrada enfeitando a tela. (Desabilitado com motivo é para configuração contextual, não para a vitrine.)
- Atalhos e glifos mostram o dispositivo atual (o remapeamento manda); navegar faz som discreto só onde o desenho pede (foco de controle em rajada não é instrumento musical — `godot-ui-ux`).

## Erros clássicos

- Três splashes + "pressione start" que não aceita o controle.
- Continuar desabilitado cinza na primeira tela de quem nunca jogou.
- Menu que carrega o mundo inteiro (e demora) só para ter fundo bonito.
- Sair focado por padrão: Enter distraído fecha o jogo.

---
_Orientação criada em 2026-10-17 com base nas regras de UX do pacote (`godot-ui-ux`). Menu se aprova navegando de controle, cronometrado, nas duas línguas._
