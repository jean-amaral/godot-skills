# Matriz de versões da Godot

Última verificação: **2026-10-16**, com `tests/project/check_classes.gd`
(`ClassDB.class_exists()`) rodado de verdade na **4.7.2** e na **4.5.1**:
na 4.5.1, `AreaLight3D`, `IKModifier3D`, `DrawableTexture2D`,
`VirtualJoystick` e `AwaitTweener` retornaram `false`, e os equivalentes
antigos (`SkeletonIK3D`, `OmniLight3D`, `SpotLight3D`, `TouchScreenButton`)
retornaram `true` — como a tabela abaixo registra. Rode o script com cada
Godot antes de atualizar esta tabela; não copie a linha de outra versão.

## Recursos por versão

| Recurso | 4.7.2 | 4.5.x | Equivalente antigo |
|---|---|---|---|
| `AreaLight3D`, saída HDR | ✅ verificado | ❌ | `OmniLight3D`/`SpotLight3D` + emissivo e GI |
| `IKModifier3D` (`TwoBoneIK3D`, `ChainIK3D`) | ✅ (desde 4.6) | ❌ | `SkeletonIK3D` |
| `DrawableTexture2D` | ✅ verificado | ❌ | `Decal` ou pintura via `SubViewport` |
| `VirtualJoystick` | ✅ verificado | ❌ | `TouchScreenButton` ou joystick de addon |
| `AwaitTweener` | ✅ verificado | ❌ | `Tween` clássico com `await tween.finished` |
| Jolt Physics (`JoltPhysics3D`) | ✅ padrão | ✅ (desde 4.4) | — |
| Sufixos `-col`/`-colonly`/`-occ` | ✅ testado em `.glb` | ✅ | — (mesmo pipeline) |
| `SkeletonIK3D`, `OmniLight3D`, `SpotLight3D` | ✅ | ✅ verificado | — |

## Ao migrar de versão

Esta matriz diz **o que existe** em cada versão, não faz a migração. Para
subir um projeto 4.5 → 4.7, siga os guias oficiais **salto a salto**
(4.5 → 4.6, estabilize, 4.6 → 4.7) e só então troque os equivalentes antigos
pelos recursos novos — nunca prometa conversão automática entre versões.

- [Upgrading to Godot 4.6](https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.6.html)
- [Upgrading to Godot 4.7](https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.7.html)

## Como ler

- ✅ verificado = classe conferida via `ClassDB` e, quando há script da skill
  envolvido, comportamento executado na suíte `tests/`.
- A coluna 4.5.x só entra com o script rodado numa Godot 4.5 real. Enquanto
  uma célula não tiver sido medida, trate o recurso como **não confirmado**
  naquela versão e use o equivalente antigo.
- Scripts desta skill (`PropAligner`, `SceneAuditor`, `SaveSystem`,
  `DevlogRecorder`) usam apenas API presente desde a 4.2; a suíte, porém,
  é rodada e garantida na 4.7.2.

## Fontes oficiais

- [Classes da engine (docs)](https://docs.godotengine.org/en/stable/classes/index.html)
- [Importing 3D scenes](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/index.html)
- [Command line tutorial](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)
- [Using Jolt Physics](https://docs.godotengine.org/en/stable/tutorials/physics/using_jolt_physics.html)
