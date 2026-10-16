# Testes — godot-visual-craft

```powershell
$env:GODOT_PATH = "C:\caminho\Godot_v4.7.2-stable_win64_console.exe"
.\tests\run_tests.ps1
```

O que a rodada prova na Godot 4.7.2 headless: os 4 shaders de `../shaders/`
carregam como recurso `Shader` em modo espacial, têm as funções esperadas
(`vertex`/`fragment`), chaves balanceadas, aceitam `ShaderMaterial` numa
malha em árvore por alguns frames e não geram `SHADER ERROR` na saída.

O que ela **não** prova: o resultado visual compilado com GPU (água
refletindo, vidro refratando). Headless usa renderização dummy; a aprovação
visual é a comparação lado a lado com a referência, na cena e com a luz
final, como manda o protocolo de pesquisa da skill.
