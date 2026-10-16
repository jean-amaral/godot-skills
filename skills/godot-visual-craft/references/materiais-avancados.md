# Materiais avançados: além do PBR básico

Base em `godot-3d-specialist/references/materiais-e-shaders.md`; aqui é o
acabamento que separa "textura aplicada" de superfície crível.

## Escala de texel consistente

O erro visual nº 1 de cena montada com asset de várias fontes: cada prop
com uma densidade de textura. Defina a régua do projeto (ex.: 512 px por
metro em parede herói, 256 no resto) e ajuste `uv1_scale` por material
para obedecê-la. Textura 4K em caixa de 20 cm é borrão caro; 256 px em
parede de 6 m é sopa.

## Camadas e desgaste (onde o realismo mora)

Superfície real = material-base + história. Em ordem de custo:

1. **Variação macro**: ruído de baixa frequência no albedo/roughness
   quebra a repetição sem textura nova.
2. **Desgaste por máscara**: borda exposta clareia, rodapé escurece com
   sujeira subindo, ponto de contato perde brilho. Máscara pintada ou
   gerada (altura/curvatura) — uma para o prop inteiro.
3. **Detalhe próximo**: detail normal de alta frequência em segunda escala
   de UV devolve grão ao chegar perto sem subir a resolução base.

Cada camada precisa de referência dizendo onde ela aparece; desgaste
uniforme "para parecer real" lê como sujeira de filtro.

## Materiais especiais (receita curta)

- **Metal pintado**: metallic 0 na tinta, 1 só onde a tinta lascou (máscara).
- **Madeira**: roughness varia **ao longo** do veio; verniz é camada, não a madeira inteira brilhando.
- **Pedra/concreto**: normal forte + roughness alto e variado; molhado = roughness cai e albedo escurece (estado, não material novo).
- **Tecido**: brilho de borda (sheen) suave e normal de trama fina; nada de specular duro.

## Variação por instância sem duplicar recurso

Dez caixas iguais com o mesmo `.tres` leem como cópia. Varie por
`instance uniform`/parâmetro por instância (matiz, sujeira, fase) dentro
de uma faixa medida na referência — variação sem faixa vira arco-íris.
Ver também a regra anti-duplicação do pacote-mãe.

---
_Referência revisada em 2026-10-16 (Godot 4.7.2). A suíte `tests/` prova os scripts do pacote; as receitas daqui são orientação de uso, não comportamento testado. Documentação oficial: [classes](https://docs.godotengine.org/en/stable/classes/index.html) · [linha de comando](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)._
