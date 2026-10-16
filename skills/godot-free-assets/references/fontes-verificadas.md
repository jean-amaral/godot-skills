# Fontes verificadas de assets gratuitos (CC0/CC-BY)

Verificado em 2026-10-16: endpoints de Poly Haven e ambientCG respondendo,
licenças conferidas nas páginas oficiais. Reconfira a licença **do item**
antes de cada download — fonte boa com item mal licenciado continua fora.

## API primeiro (CC0 integral, sem chave)

| Fonte | O que tem | Licença | Como buscar/baixar |
|---|---|---|---|
| [Poly Haven](https://polyhaven.com) | Texturas PBR, HDRIs e modelos 3D fotográficos | CC0 (tudo) | `GET https://api.polyhaven.com/assets?t=models\|textures\|hdris` lista; `GET https://api.polyhaven.com/files/<id>` devolve URLs e hashes por resolução/formato. Exige User-Agent identificável; a página de licença pede crédito à API (termo da API, separado do CC0 do asset). Prefira `.glb`/glTF e 1K/2K. |
| [ambientCG](https://ambientcg.com) | Materiais PBR (mapas completos) e HDRIs | CC0 (tudo) | `GET https://ambientcg.com/api/v2/full_json?q=<termo>&limit=<n>` busca; o download é o zip por material/resolução (ex.: `<Id>_1K-JPG.zip`). Para a Godot, confira o mapa Normal no padrão GL. |
| [Kenney](https://kenney.nl/assets) | Pacotes de jogo: 3D kits, 2D, UI e áudio | CC0 (tudo) | Sem API: a página do pacote (`kenney.nl/assets/<slug>`) contém o link direto do `.zip`. O `License.txt` dentro do zip é a evidência forte. Pacotes 3D trazem FBX/OBJ/glTF conforme o kit — confira antes. |
| KayKit (GitHub) | Personagens e kits low-poly estilizados | CC0 | Repositórios públicos com `LICENSE` no GitHub; baixe o zip do repositório ou o release, e guarde o `LICENSE` junto. |

## Licença por item (filtrar na fonte, conferir um a um)

| Fonte | O que tem | Cuidado |
|---|---|---|
| [OpenGameArt](https://opengameart.org) | 2D, 3D, áudio, texturas — acervo enorme e irregular | Na busca avançada, marque **só** CC0 e/ou CC-BY. Cada upload tem licença própria; abra a página do item e o arquivo de licença do pacote. |
| [Freesound](https://freesound.org) | Efeitos sonoros de todo tipo | Filtre por "Creative Commons 0" ou CC-BY na busca. API e download em qualidade original pedem conta/token — sem token, use a página oficial; nunca credencial de terceiros. |
| [itch.io (assets grátis)](https://itch.io/game-assets/free) | Pacotes indies 2D/3D/áudio de qualidade variada | "Free" no itch **não** é licença: só entra se a página do pacote declarar CC0 ou CC-BY (muitos declaram licença própria). Download pelo fluxo normal da página, sem automação que burle a loja. |
| Godot Asset Library | Addons, cenas e assets para Godot | Licença é a do repositório de cada item (muita coisa MIT, que está **fora** do critério CC0/CC-BY desta skill): só use se o item declarar CC0/CC-BY, ou trate como exceção aprovada pelo criador e registrada. |

## Fora por padrão

- Lojas "free" com licença própria restritiva, bancos com licença editorial, e qualquer fonte que impeça uso comercial ou exija não-modificação.
- Sketchfab e similares: só item marcado CC0/CC-BY **e** baixável; conferir a licença na página do modelo, nunca pelo título da coleção.
- Agregadores/mirrors de pacotes: a procedência some e a licença vira boato.

## Compatibilidade rápida com a Godot

| Tipo | Formato preferido | Conferir |
|---|---|---|
| Modelo 3D | `.glb` (binário, um arquivo) | Escala em metros, origem, vem com textura embutida? |
| Textura PBR | PNG/JPG 1K–2K, mapas separados | Albedo sRGB; normal/roughness lineares; normal em padrão GL |
| HDRI | `.hdr`/`.exr` | Resolução 2K basta para fundo/iluminação comum |
| Áudio | WAV (curto) / OGG (longo e música) | Sample rate e loop limpo; normalizar volume no projeto |
| Fonte de letra | — | Fontes costumam ser OFL, **fora** do critério CC0/CC-BY: não baixe por esta skill sem exceção registrada |
| UI/sprites | PNG com transparência | Margens e fatiamento 9-slice quando for painel |

---
_Verificado em 2026-10-16. Documentação: [Poly Haven](https://polyhaven.com/license) · [ambientCG](https://ambientcg.com) · [Kenney](https://kenney.nl) · [OpenGameArt](https://opengameart.org)._
