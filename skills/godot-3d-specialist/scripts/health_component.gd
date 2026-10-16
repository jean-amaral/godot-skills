class_name HealthComponent
extends Node

## Vida de entidade: dano com i-frames, cura, morte e revive por sinais.
## Copie para res://scripts/components/health_component.gd e ouça os sinais;
## quem causa dano chama damage(), ninguém mexe em current_health por fora.

signal health_changed(current: float, maximum: float)
signal damaged(amount: float)
signal died
signal revived

@export var max_health: float = 100.0
@export var invulnerability_seconds: float = 0.0

var current_health: float
var _invulnerable_until_msec: int = 0
var _initialized := false

func _ready() -> void:
	_ensure_initialized()

## Inicialização preguiçosa: antes do _ready o componente já responde
## (current_health = max_health), em vez de parecer morto com 0.
func _ensure_initialized() -> void:
	if not _initialized:
		current_health = max_health
		_initialized = true

func is_dead() -> bool:
	_ensure_initialized()
	return current_health <= 0.0

## Aplica dano. Retorna true se o dano entrou (vivo e fora de i-frames).
func damage(amount: float, ignore_invulnerability: bool = false) -> bool:
	if amount <= 0.0 or is_dead():
		return false
	var now := Time.get_ticks_msec()
	if not ignore_invulnerability and now < _invulnerable_until_msec:
		return false
	current_health = maxf(current_health - amount, 0.0)
	if invulnerability_seconds > 0.0:
		_invulnerable_until_msec = now + int(invulnerability_seconds * 1000.0)
	damaged.emit(amount)
	health_changed.emit(current_health, max_health)
	if is_dead():
		died.emit()
	return true

func heal(amount: float) -> void:
	if amount <= 0.0 or is_dead():
		return
	current_health = minf(current_health + amount, max_health)
	health_changed.emit(current_health, max_health)

func revive(to_health: float = -1.0) -> void:
	if not is_dead():
		return
	current_health = max_health if to_health < 0.0 else clampf(to_health, 1.0, max_health)
	_invulnerable_until_msec = 0
	health_changed.emit(current_health, max_health)
	revived.emit()
