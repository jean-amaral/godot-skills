extends SceneTree

class CountingState:
	extends Node
	var enters := 0
	var resumes := 0
	func enter() -> void:
		enters += 1
	func enter_resume() -> void:
		resumes += 1

class ReentrantState:
	extends Node
	var machine: StateMachine
	var attempted := false
	func enter() -> void:
		if not attempted:
			attempted = true
			machine.transition_to(&"patrol")

var _failures := 0
var _ran := false

func _check(label: String, cond: bool, detail: String = "") -> void:
	print(("PASS " if cond else "FAIL ") + label + " " + detail)
	if not cond:
		_failures += 1

func _initialize() -> void:
	process_frame.connect(_run)

func _run() -> void:
	if _ran:
		return
	_ran = true

	# --- HealthComponent (pre-ready: nao pode parecer morto com 0) ---
	var pre := HealthComponent.new()
	pre.max_health = 40.0
	_check("pre-ready responde com vida cheia", not pre.is_dead() and pre.damage(10.0)
		and pre.current_health == 30.0)
	pre.free()

	# --- HealthComponent ---
	var health := HealthComponent.new()
	health.max_health = 50.0
	health.invulnerability_seconds = 60.0
	root.add_child(health)
	var died_count := [0]
	health.died.connect(func() -> void: died_count[0] += 1)
	_check("vida cheia ao entrar", health.current_health == 50.0)
	_check("dano entra", health.damage(20.0) and health.current_health == 30.0)
	_check("i-frames bloqueiam", not health.damage(20.0) and health.current_health == 30.0)
	_check("dano ignorando i-frames mata", health.damage(999.0, true) and health.is_dead())
	_check("died emitido uma vez", died_count[0] == 1)
	health.heal(10.0)
	_check("morto nao cura", health.current_health == 0.0)
	health.revive(25.0)
	_check("revive restaura", health.current_health == 25.0 and not health.is_dead())

	# --- StateMachine ---
	var machine := StateMachine.new()
	root.add_child(machine)
	var patrol := Node.new()
	var chase := Node.new()
	root.add_child(patrol)
	root.add_child(chase)
	machine.register_state(&"patrol", patrol)
	machine.register_state(&"chase", chase)
	var can_chase := [false]
	machine.set_guard(&"chase", func() -> bool: return can_chase[0])
	_check("start patrol", machine.start(&"patrol") and machine.current_state == &"patrol")
	_check("guard bloqueia chase", not machine.transition_to(&"chase"))
	can_chase[0] = true
	_check("guard liberado transita", machine.transition_to(&"chase"))
	_check("push/pop de estado", machine.push_state(&"patrol") and machine.pop_state()
		and machine.current_state == &"chase")
	_check("estado desconhecido recusado", not machine.transition_to(&"nao_existe"))

	# Regressão: push que falha sem estado atual não toca o histórico.
	var fresh := StateMachine.new()
	root.add_child(fresh)
	fresh.register_state(&"patrol", patrol)
	_check("push falho sem estado atual", not fresh.push_state(&"nao_existe"))
	_check("historico intacto apos push falho", not fresh.pop_state())
	_check("push falho com guard nao empilha", fresh.start(&"patrol")
		and not fresh.push_state(&"nao_existe") and not fresh.pop_state())

	# Retomada x entrada fresca, e reentrada recusada.
	var machine2 := StateMachine.new()
	root.add_child(machine2)
	var state_a := CountingState.new()
	var state_b := CountingState.new()
	root.add_child(state_a)
	root.add_child(state_b)
	machine2.register_state(&"a", state_a)
	machine2.register_state(&"b", state_b)
	machine2.start(&"a")
	machine2.push_state(&"b")
	machine2.pop_state()
	_check("pop retoma sem repetir enter", state_a.enters == 1 and state_a.resumes == 1,
		"enters=%d resumes=%d" % [state_a.enters, state_a.resumes])
	var machine3 := StateMachine.new()
	root.add_child(machine3)
	var reentrant := ReentrantState.new()
	reentrant.machine = machine3
	root.add_child(reentrant)
	machine3.register_state(&"reentrant", reentrant)
	machine3.register_state(&"patrol", state_a)
	_check("transicao reentrante recusada", machine3.start(&"reentrant")
		and machine3.current_state == &"reentrant")

	print("COMPONENTS_DONE failures=", _failures)
	quit(1 if _failures > 0 else 0)
