---
name: godot-free-assets
description: Busca, verifica licença (somente CC0 e CC-BY), apresenta para confirmação e baixa assets 100% gratuitos compatíveis com o projeto Godot em desenvolvimento, registrando créditos, checksums e procedência. Use quando o criador pedir asset, modelo 3D, textura, HDRI, áudio, fonte ou UI gratuita para um projeto Godot.
---

# Godot Free Assets

Encontre assets gratuitos **de verdade** para o projeto Godot em mãos: primeiro entenda o que o projeto precisa, depois busque nas fontes verificadas, prove a licença, apresente as opções e só baixe o que o criador confirmar — com crédito e checksum registrados.

## Quando usar

- "Preciso de um barril 3D / textura de madeira / som de porta / HDRI para esta cena."
- Completar um prop, material, ambiente ou som que o projeto (GDD, catálogo de props, cena) já pede.
- Substituir placeholder por asset real sem custo e sem risco de licença.

Não use para: asset pago ou "grátis" com licença restritiva, baixar de site que exige burlar login/paywall/captcha, conteúdo que o projeto não pediu (colecionar asset não é progresso), nem para redistribuir pacotes como se fossem seus.

## Regra de licença (inegociável)

Só entra no projeto asset com licença **CC0** ou **CC-BY**, verificada em pelo menos duas evidências, nesta ordem de força:

1. Arquivo de licença dentro do pacote baixado (`License.txt`/`LICENSE`).
2. Página oficial de licença da fonte (ex.: página de licença do Poly Haven/Kenney).
3. Campo de licença na página do asset ou na resposta da API.

Fora, por padrão: CC-BY-SA, CC-BY-NC, CC-BY-ND, OGA-BY, GPL, "free" sem licença nomeada, licença própria de loja e qualquer asset cuja licença você não conseguiu abrir. Divergência entre evidências = **não baixa** e reporta. Busca/snippet nunca é evidência de licença.

Crédito: CC0 não exige, mas registramos a fonte por cortesia e rastreio. **CC-BY exige**: autor, título, link da fonte, link da licença e indicação de alterações — o script de download gera isso automaticamente a partir do manifesto.

## Fluxo

### 1. Entender o pedido no projeto

Leia o contexto antes de buscar: `project.godot` (versão/renderizador), GDD/catálogo de props, estilo visual declarado, formato necessário (ex.: prop 3D em metros com pivô na base, textura PBR 1K/2K, áudio curto) e onde o asset vai morar. Busca sem brief vira download inútil: defina tipo, estilo, formato e tamanho máximo aceitáveis em uma frase.

**Estilo padrão: realista.** Sem estilo declarado no projeto, busque asset realista (fotográfico/PBR — Poly Haven e ambientCG primeiro) e modular quando for construção. Se o criador quiser outro estilo (estilizado, low-poly, toon), isso vem do brief/GDD — não presuma nem misture estilos no mesmo ambiente.

**Pesquisa antes da busca** (protocolo de todas as skills do pacote): quando o asset define visual (textura herói, prop de destaque, ambiente), colete a referência visual do projeto primeiro (foto do mundo real/obra no estilo, como em `godot-3d-specialist/references/pesquisa-e-referencias.md`) e derive dela os termos de busca, a paleta e o formato — buscar por palavra solta traz asset bonito no estilo errado.

### 2. Buscar nas fontes verificadas (API primeiro)

Consulte [references/fontes-verificadas.md](references/fontes-verificadas.md). Prioridade: fontes com API/CC0 integral (Poly Haven, ambientCG, Kenney, Quaternius/KayKit), depois fontes com licença por asset (OpenGameArt, Freesound, itch.io) filtrando **na fonte** por CC0/CC-BY. Respeite termos de cada API/site: User-Agent identificável, ritmo moderado, nada de contornar controle de acesso.

### 3. Apresentar antes de baixar

Mostre a lista curta ao criador e **espere a confirmação**: nome, fonte e autor, licença com link da evidência, formato e tamanho, compatibilidade com a Godot (formato importável, escala/origem quando se sabe) e se exige atribuição. Sem confirmação, nenhum download — mesmo sendo grátis.

### 4. Baixar com o script e manifesto

Monte o manifesto (modelo em [templates/manifest-exemplo.json](templates/manifest-exemplo.json)) só com itens confirmados e rode [scripts/download_assets.ps1](scripts/download_assets.ps1) em modo `-Approved`. O script: recusa licença fora de CC0/CC-BY, baixa com User-Agent próprio, calcula SHA-256, grava `asset_manifest.json` no destino e gera/atualiza `CREDITS.md` com os créditos CC-BY (e CC0 por cortesia). Destino padrão no projeto: `assets/external/<fonte>/<asset>/`, ao lado do `LICENSE` do pacote quando houver.

### 5. Conferir e integrar

- Confira checksum/tamanho e abra o arquivo: modelo em formato importável (`.glb` preferido; `.blend`/FBX só se o projeto aceita), textura em PNG/JPG com mapas certos, áudio em WAV/OGG.
- Extraia zip com cuidado de caminho (o script recusa entrada que escapa da pasta) e nunca execute instalador/script que venha dentro de pacote de asset.
- Rode a importação da Godot (`godot --headless --import --quit`) quando houver projeto, e ajuste o asset às convenções do projeto (escala métrica, pivô, colisor) usando o pacote `godot-3d-specialist` quando for 3D.
- Registre no catálogo de props/devlog o que entrou, de onde e sob qual licença.

## Nunca

- Baixar de agregador de "assets grátis" sem licença nomeada na página do asset.
- Confiar em filtro de busca sem abrir a licença do item.
- Usar asset CC-BY sem gerar o crédito no ato do download.
- Baixar pacote inteiro de centenas de MB por um item só sem avisar o tamanho e oferecer a alternativa menor (resolução menor, item avulso).
- Apagar `License.txt`, manifesto ou créditos ao limpar a pasta de assets.

## Arquivos desta skill

| Arquivo | Conteúdo |
|---|---|
| [references/fontes-verificadas.md](references/fontes-verificadas.md) | Fontes por tipo, licença, API e como buscar/baixar em cada uma |
| [references/licencas.md](references/licencas.md) | Tabela de decisão CC0/CC-BY, recusas e formato do crédito |
| [scripts/download_assets.ps1](scripts/download_assets.ps1) | Download aprovado com SHA-256, manifesto e CREDITS.md |
| [templates/manifest-exemplo.json](templates/manifest-exemplo.json) | Manifesto de itens confirmados, pronto para preencher |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de mudanças da skill |
