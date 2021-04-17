extends Node2D

class_name Weapon

signal shoot()
signal ammo_changed(newAmmo)
signal empty()

var maxAmmo : int = 1000
var ammo : int = 1000  setget _setAmmo, _getAmmo
var cooldown : float = 0.1

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
		ammo -= 1
		_timer.start(cooldown)
		_fireSound.play()
		emit_signal("shoot")
		emit_signal("ammo_changed", ammo)
		if ammo == 0:
			emit_signal("empty")

func canFire() -> bool:
	return ammo > 0 and is_zero_approx(_timer.get_time_left())

func _setAmmo(newAmmo : int) -> void:
   ammo = clamp(newAmmo, 0, maxAmmo) as int
   emit_signal("ammo_changed", ammo)

func _getAmmo() -> int:
   return ammo

func _createProjectileInstance() -> void:
	var instance : Node2D = _projectileScene.instance()
	instance.setup(_shooter)
	instance.transform = _muzzle.global_transform
	_projectileStore.add_child(instance)
