class_name StateMachine
extends Node

## Máquina de estados fina com guards e histórico (pushdown).
## Copie para res://scripts/components/state_machine.gd.
##
## Uso: registre estados por nome (nós filhos com enter()/exit() opcionais),
## defina guards por Callable e transicione com transition_to()/push_state().
## Hierarquia de verdade se compõe aninhando máquinas (uma por personagem,
## outra por sub-comportamento), não com uma classe gigante.
## Estados NÃO devem chamar transition_to() sincronamente dentro de enter():
## a máquina recusa transição reentrante — agende com call_deferred.

signal state_changed(from_state: StringName, to_state: StringName)

## Teto da pilha de pushdown: push sem pop correspondente é vazamento.
@export var max_history_depth: int = 16

var _states: Dictionary[StringName, Node] = {}
var _guards: Dictionary[StringName, Callable] = {}
var _history: Array[StringName] = []
var _in_transition := false

var current_state: StringName = &""

func register_state(state_name: StringName, node: Node) -> void:
	_states[state_name] = node

func set_guard(state_name: StringName, guard: Callable) -> void:
	_guards[state_name] = guard

func start(initial: StringName) -> bool:
	return transition_to(initial, true)

func transition_to(state_name: StringName, force: bool = false) -> bool:
	return _transition(state_name, force, false)

func _transition(state_name: StringName, force: bool, resumed: bool) -> bool:
	if _in_transition:
		push_warning("StateMachine: transição reentrante recusada (use call_deferred).")
		return false
	if not _states.has(state_name):
		push_warning("StateMachine: estado desconhecido: " + String(state_name))
		return false
	if state_name == current_state and not force:
		return true
	if not force and _guards.has(state_name) and not bool(_guards[state_name].call()):
		return false
	_in_transition = true
	_exit_current()
	var previous := current_state
	current_state = state_name
	var node := _states[state_name]
	if resumed and node.has_method("enter_resume"):
		node.call("enter_resume")
	elif node.has_method("enter"):
		node.call("enter")
	_in_transition = false
	state_changed.emit(previous, state_name)
	return true

## Empilha o estado atual e vai para `state_name` (ex.: "morto" sobre "combate").
## Se a transição falhar, o histórico fica exatamente como estava.
func push_state(state_name: StringName) -> bool:
	if _history.size() >= max_history_depth:
		push_warning("StateMachine: pilha cheia (max_history_depth); push recusado.")
		return false
	var pushed := current_state != &""
	if pushed:
		_history.append(current_state)
	if not transition_to(state_name):
		if pushed:
			_history.pop_back()
		return false
	return true

## Volta ao estado empilhado mais recente, como RETOMADA: se o estado
## tiver enter_resume(), é ele quem roda (sem repetir efeito de entrada).
func pop_state() -> bool:
	if _history.is_empty():
		return false
	return _transition(_history.pop_back(), true, true)

func _exit_current() -> void:
	if current_state != &"" and _states.has(current_state):
		if _states[current_state].has_method("exit"):
			_states[current_state].call("exit")
