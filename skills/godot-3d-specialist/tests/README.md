# Suíte permanente de testes da skill

Testa os scripts de `../scripts/` na Godot real, headless. Se um caso falhar,
corrija o script — não o esperado — salvo se o comportamento correto mudou;
nesse caso, atualize `expected/` e o `CHANGELOG.md` na mesma entrega.

## Como rodar (Windows)

```powershell
$env:GODOT_PATH = "C:\caminho\Godot_v4.7.2-stable_win64_console.exe"
.\tests\run_tests.ps1
```

Sem `GODOT_PATH`, o runner procura `godot` no PATH. Código de saída 1 = falha.

## O que é coberto

| Área | Arquivo | O que prova |
|---|---|---|
| PropAligner | `project/test_aligner.gd` | Pai deslocado, alvo rotacionado, prop escalado, rampa física |
| SaveSystem | `project/test_save_system.gd` | Ida-e-volta, rotação por quaternion, save corrompido não aplica, principal adulterado cai ao `.bak` (SHA-256) |
| Componentes | `project/test_components.gd` | `HealthComponent` (dano/i-frames/morte/revive) e `StateMachine` (guard, push/pop) |
| CSG e material | `project/test_csg_material.gd` | Bake de parede CSG com vão (AABB + colisão) e `PbrMaterialBuilder` salvando `.tres` |
| DevlogRecorder | `project/test_recorder.gd` | Nome determinístico dos frames (captura real exige render, fora do headless) |
| Importação | `project/export_glb.gd` + `test_import.gd` | Sufixos `-col`, `-colonly`, `-occ` num `.glb` gerado na hora |
| SceneAuditor | `project/gen_fixtures.gd` + `expected/auditor_expected.json` | 8 cenas: válida, escalas, colisor ausente, flutuante, malha vazia, duplicados, luzes |
| Auditor config | `audit_config_test.json` | Multi-cena, `ignore_types`, `max_lights` gerando `TOO_MANY_LIGHTS` |
| Devlog HTML | runner (Edge headless) | Página abre e o painel lê `audit_report.json` (pula se não houver Edge) |
| Versões | `project/check_classes.gd` | Imprime existência de classes por engine; base da matriz de versões |

As cenas-fixture são geradas por `gen_fixtures.gd` a cada rodada (não edite
`.tscn` gerado à mão). A única cena manual é `scenes_src/duplicate.tscn`,
porque nomes duplicados não se criam pela API de nós.
