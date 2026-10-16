# Mundo 3D avançado: kits, streaming e ritmo

## GridMap e MeshLibrary (quando o kit é grade)

- Nível modular repetitivo (corredor, masmorra, cidade em grade) rende mais em `GridMap` + `MeshLibrary` do que em centenas de `.tscn` soltos: cada item da biblioteca já carrega malha, colisão e oclusão.
- Item da biblioteca segue a mesma métrica do pacote (módulo 1/2/4 m, pivô na base); grade desalinhada nasce na biblioteca, não no nível.
- Fora da grade (heróis, marcos únicos), volta o prop `.tscn` — misturar os dois é o normal, não exceção.

## Greybox que vira nível

`CSGCombiner3D` é blocagem e validação de fluxo, não geometria final: serve para provar escala, rota e encontro. Ao promover o trecho, substitua por kit modular mantendo as cotas medidas no CSG — a blocagem aprovada é a planta do nível final.

## Streaming e mundo grande

- Divida por células/bairros com fronteira de carga testável; carregue threaded (ver [arquitetura-e-fundacao.md](arquitetura-e-fundacao.md)) e descarregue atrás do jogador por distância **com histerese** (entra a 80 m, sai a 100 m) para não piscar na fronteira.
- Visibilidade antes de polígono: `OccluderInstance3D` em massa arquitetônica, alcance de câmera por camada (`Cull Mask`/range) e LOD de malha/importação fazem mais pelo frame do que micro-otimizar shader.
- Geração procedural entra com **seed registrada** (mesma seed, mesmo mundo): salve a seed no save e no relatório de bug, ou o defeito não reproduz.
- Terreno: malha dedicada com colisão côncava estática; validar alcançabilidade (spawn, portas, rotas) **antes** de espalhar props — prop bonito em lugar inalcançável é retrabalho.

## Ritmo do mundo

- Ciclo dia/noite é um relógio único dono de sol, ambiente e spawns; cada sistema lê o relógio, ninguém gira o próprio sol.
- Névoa (`Fog`) e ambiente mudam por zona com transição suave, não por corte seco ao cruzar a porta.
- Reflexos locais: `ReflectionProbe` por sala relevante com projeção em caixa ajustada — um probe gigante para o mapa inteiro lava os interiores.

---
_Referência revisada em 2026-10-16 (Godot 4.7.2). A suíte `tests/` prova os scripts do pacote; as receitas daqui são orientação de uso, não comportamento testado. Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
