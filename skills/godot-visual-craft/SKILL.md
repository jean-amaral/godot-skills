---
name: godot-visual-craft
description: Criação visual realista na Godot 4.7+ — shaders espaciais, materiais PBR avançados, animação 3D e efeitos, sempre a partir de pesquisa com referências visuais analisadas. Use quando o criador pedir shader, material realista, animação, visual de prop/cenário ou polimento visual em projeto Godot 3D.
---

# Godot Visual Craft

Crie o visual do jogo como um technical artist sênior: **pesquisa primeiro, referência analisada na mesa, construção depois, comparação lado a lado no fim**. Shader bonito sem referência é chute com brilho.

## Quando usar

- Criar ou ajustar shader realista (água, vidro, terreno, folhagem, emissivo, dano).
- Construir material PBR convincente a partir de texturas (baixadas com a skill `godot-free-assets` quando forem externas).
- Animar personagem/prop com peso e intenção (locomoção, ataque, idle vivo, root motion, IK).
- Dar o acabamento visual de um prop ou cenário que já funciona mas "parece jogo amador".

Para arquitetura/métrica/auditoria, o pacote-mãe é `godot-3d-specialist`; esta skill é a camada de **aparência e movimento**.

## Protocolo de pesquisa (obrigatório, antes de criar)

Vale para shader, material, animação e efeito — sem exceção:

1. **Perguntas**: o que exatamente precisa parecer/fazer? (ex.: "água de rio raso sobre pedra", "caminhada cansada com mochila").
2. **Referências**: foto/vídeo do fenômeno real, obra no estilo contratado (padrão: realista) e documentação da engine na versão do projeto. Referência é estudo: não embuta imagem protegida no projeto; asset baixável vem da `godot-free-assets` (CC0/CC-BY).
3. **Análise mensurável**: extraia da referência o que se constrói — no visual: silhueta, paleta (hex), como a luz atravessa/reflete, escala do detalhe, ritmo e peso (na animação: tempos, antecipação, arcs). Registre num painel como o de `godot-3d-specialist/templates/painel-referencias.md`.
4. **Especificação**: parâmetros-alvo (cores, intensidades, tempos, curvas) escritos antes de abrir o editor de shader/animação.
5. **Comparação**: capture na mesma câmera/pose da referência e corrija diferença por diferença. Quem aprova é a comparação, não quem fez.

## Padrões por disciplina

### Shaders realistas

- Comece do fenômeno físico simplificado: luz, superfície e observador — [references/shaders-realistas.md](references/shaders-realistas.md) traz as receitas-base testadas deste pacote (água, vidro, terreno, folhagem, pulso emissivo) em [shaders/](shaders/).
- Parâmetro exposto (`uniform`) com nome do mundo real (`water_color_deep`, `flow_speed`), valor padrão seguro e faixa útil comentada. Shader sem material continua legível.
- Custo declarado: tela cheia, transparência e leitura de profundidade têm preço — um efeito herói por vez, com alternativa barata anotada.

### Materiais PBR

- A física manda: albedo sRGB, dados lineares, metal quase sempre 0 ou 1, roughness mandando no brilho. Detalhamento em [references/materiais-avancados.md](references/materiais-avancados.md) (camadas, desgaste por máscara, triplanar, escala de texel consistente).
- Material é recurso compartilhado `.tres`; variação por instância é uniforme, não duplicação — construção assistida por `godot-3d-specialist/scripts/pbr_material_builder.gd`.

### Animação

- Peso vem de tempo e antecipação, não de keyframe a mais: [references/animacao-avancada.md](references/animacao-avancada.md) (ciclo de locomoção, ataque em fases, idle respirando, root motion, IK e blend em camadas).
- Animação reflete estado de gameplay, nunca decide por ele; evento (passo, golpe) nasce na track, sincronizado.
- Referência de movimento se estuda em vídeo com tempos marcados (contato, passagem, ápice), não "de olho" numa pose só.

## Arquivos desta skill

| Arquivo | Conteúdo |
|---|---|
| [references/shaders-realistas.md](references/shaders-realistas.md) | Receitas e parâmetros dos shaders-base realistas |
| [references/materiais-avancados.md](references/materiais-avancados.md) | PBR em camadas, desgaste, texel e variação por instância |
| [references/animacao-avancada.md](references/animacao-avancada.md) | Movimento com peso: ciclos, fases, root motion, IK e blends |
| [shaders/realistic_water.gdshader](shaders/realistic_water.gdshader) | Água com fluxo, fresnel e espuma de borda |
| [shaders/realistic_glass.gdshader](shaders/realistic_glass.gdshader) | Vidro com fresnel, tinta e reflexo barato |
| [shaders/terrain_blend.gdshader](shaders/terrain_blend.gdshader) | Terreno por altura/inclinação com dois materiais |
| [shaders/foliage_wind.gdshader](shaders/foliage_wind.gdshader) | Folhagem com vento por vértice e variação por instância |
| [tests/README.md](tests/README.md) | Como os shaders são validados na engine |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de mudanças da skill |
