# Gêneros e nichos (conceitos, sob demanda)

Este arquivo guarda princípios de gênero que **não** viram sistema próprio neste pacote: entram como decisão de design quando o projeto é daquele gênero. Sistemas reutilizáveis de verdade estão em [sistemas-de-gameplay.md](sistemas-de-gameplay.md).

## Estrutura por gênero

- **Action-RPG / shooter (3D)**: combate de [sistemas-de-gameplay.md](sistemas-de-gameplay.md) + câmera e consultas de [fisica-e-consultas-3d.md](fisica-e-consultas-3d.md). O gênero não muda a arquitetura; muda números e feedback.
- **Horror/stealth**: percepção e pressão de [navegacao-e-ia-3d.md](navegacao-e-ia-3d.md); esconderijo precisa ser legível (o jogador entende por que foi visto).
- **Corrida/esporte**: veículo por raycast e física contínua com passo fixo; replay/ghost é gravação de entradas com seed, não gravação de vídeo — só funciona se a simulação for determinística nos trechos gravados.
- **Estratégia/tower defense**: seleção e ordens são UI + comandos sobre unidades; caminho das ondas é navegação com alvo comum, não IA por unidade inimiga.
- **Fighting**: frame-data (startup/ativo/recuperação) é dado da animação de ataque; input com buffer e leitura de movimento (sequências direcionais) — sem rollback netcode neste pacote (multiplayer está fora de escopo).
- **Visual novel/romance/party**: diálogo de [sistemas-de-gameplay.md](sistemas-de-gameplay.md) com histórico/rollback de leitura e afinidade como stat comum; split-screen local é viewport por jogador com entrada separada por dispositivo.

## Nichos técnicos

- **Bake 3D→sprites**: renderizar modelo 3D para sprite 2D é ferramenta de editor offline (câmera + viewport dedicados, lote por ângulo/animação), com saída versionada como asset — não acontece em runtime no jogo.
- **Wrappers de plataforma (Steam/Discord etc.)**: SDK entra atrás de uma fachada própria fina (conquista, presença), para o jogo rodar sem o serviço e testar sem a plataforma aberta.
- **Web**: build web pede o renderizador de compatibilidade e persistência pelo navegador; valide save e áudio no navegador alvo cedo, não na véspera.
- **Slots criptografados**: só para dado sensível de verdade; save comum protegido por integridade (SHA-256 + backup, ver [save-load-3d.md](save-load-3d.md)) resolve adulteração acidental sem custo de chave.
- **Scaffolds de gênero**: começar um projeto por um template de gênero é atalho de protótipo; a estrutura de pastas e sistemas deste pacote continua mandando quando o protótipo vira produção.

---
_Referência revisada em 2026-10-16 (Godot 4.7.2). A suíte `tests/` prova os scripts do pacote; as receitas daqui são orientação de uso, não comportamento testado. Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
