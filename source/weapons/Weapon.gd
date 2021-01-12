extends Node2D

class_name Weapon

signal shoot()
signal ammo_gained()
signal empty()

var _maxAmmo : int = 1000
var _ammo : int = 1000
var _cooldown : float = 0.1
var _projectileScene : PackedScene
var _projectileStore : Node
var _muzzle : Muzzle
var _shooter 

onready var _fireSound : Sfx = $SfxFire
onready var _emptySound : Sfx = $SfxEmpty
onready var _timer : Timer = $Timer

func get_class() -> String:
	return "Weapon"

func setProjectileStore(projectileStore : Node, muzzle : Muzzle, shooter) -> void:
	_projectileStore = projectileStore
	_muzzle = muzzle
	_shooter = shooter

func fire() -> void:
	if canFire():
		_createProjectileInstance()
		_ammo -= 1
		_timer.start(_cooldown)
		_fireSound.play()
		emit_signal("shoot")
		if _ammo == 0:
			emit_signal("empty")

func canFire() -> bool:
	return _ammo > 0 and is_zero_approx(_timer.get_time_left())

func addAmmo(amount : int) -> void:
	_ammo = min(_maxAmmo, _ammo + amount)
	emit_signal("ammo_gained")

func getAmmo() -> int:
	return _ammo

func getMaxAmmo() -> int:
	return _maxAmmo

func _createProjectileInstance() -> void:
	var instance : Node2D = _projectileScene.instance()
	instance.setup(_shooter)
	instance.transform = _muzzle.global_transform
	_projectileStore.add_child(instance)
