# Iluminação e estilo visual

Escolha um caminho por projeto. Misturar PBR realista com toon no mesmo ambiente lê como erro, não como estilo.

**O padrão é o caminho realista** (decisão do pacote): só saia dele por decisão registrada do criador na concepção — ver [concepcao-e-entrevista.md](concepcao-e-entrevista.md). Estilo definido vale para tudo: props, materiais, luz e asset externo.

## Caminho realista (Forward+)

- Renderizador **Forward+**, tonemapper **AgX** no `WorldEnvironment` (rolagem suave de altas luzes).
- Saída **HDR** (4.7+): ative apenas mirando display HDR; o tonemapping continua obrigatório para SDR.
- Sol/lua: `DirectionalLight3D` com sombra; céu via `ProceduralSkyMaterial` ou HDRI em `PanoramaSky`.
- Iluminação global: `SDFGI` para exteriores e mundo aberto; `VoxelGI` para interiores delimitados; `LightmapGI` quando o cenário é estático e o orçamento permite assar.
- Reflexos locais: `ReflectionProbe` com `box_projection = true` dimensionado à sala.
- Fontes retangulares (janela luminosa, painel, letreiro): **`AreaLight3D` (4.7+)**. Em 4.5 ou anterior, aproxime com `OmniLight3D`/`SpotLight3D` + emissivo e GI — e registre a substituição no TDD.
- Material PBR: albedo, normal e roughness/metallic em canais corretos; nada de specular "no olho".

Orçamento: cada luz dinâmica com sombra custa. Prefira luz assada/GI para preenchimento e reserve luz dinâmica para heróis da cena.

## Caminho estilizado

- **Toon/cel**: `diffuse_mode = DIFFUSE_TOON` em `StandardMaterial3D` ou shader espacial próprio com bandas de luz; sombras duras e poucas luzes.
- **Low-poly flat**: `shading_mode = SHADING_MODE_UNSHADED` ou flat via normal de face; palette de cores travada por bioma.
- **Retro 3D**: baixe a resolução interna do viewport 3D e filtre com nearest nas texturas (`texture_filter = TEXTURE_FILTER_NEAREST`); confirme a propriedade exata de scaling na versão do projeto antes de prometer o recurso.
- **Pintura dinâmica no mundo** (trilha na neve, pegadas): `DrawableTexture2D` (4.7+) desenhando em tempo real; em versões anteriores, use decalques (`Decal`) ou `SubViewport` de pintura.

## Regras comuns aos dois caminhos

- Um único `WorldEnvironment` por cena de nível; ambiente de menu é cena separada.
- Exposição e glow se ajustam no ambiente, não compensando em cada material.
- Sombras: defina distância e tamanho de cascata pelo tamanho real do nível; sombra infinita é desperdício.
- Teste o pior caso (sala mais cheia de luzes) no Profiler antes de declarar a iluminação pronta.


---

_Referência revisada em 2026-10-16 (Godot 4.7.2). A suíte `tests/` prova os scripts do pacote; as receitas daqui são orientação de uso, não comportamento testado. Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
