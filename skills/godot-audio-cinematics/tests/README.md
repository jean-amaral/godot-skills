# Testes — godot-audio-cinematics

```powershell
$env:GODOT_PATH = "C:\caminho\Godot_v4.7.2-stable_win64_console.exe"
.\tests\run_tests.ps1
```

Prova na Godot 4.7.2 headless o `CutscenePlayer`: tocar emite `started`,
a batida da track de método emite `step_reached`, o fim normal emite
`finished(skipped=false)`, e **pular no meio emite o mesmo `finished`
(skipped=true) na hora**, com a ordem completa de eventos conferida.
Qualidade de mix, sincronia fina e enquadramento são validação auditiva/
visual contra a referência — fora do alcance do headless, como manda o
protocolo de pesquisa da skill.
