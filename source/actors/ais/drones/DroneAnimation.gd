extends Node2D

class_name DroneAnimation

var _muzzle : Position2D
var _drone : Drone = null
onready var animation : AnimationPlayer = $AnimationPlayer

func get_class() -> String:
	return "Drone"

func setup(drone : Drone, weaponSet : WeaponSet, muzzle : Position2D) -> void:
	animation.connect("animation_finished", self, "_on_animation_finished")
	weaponSet.addWeapon(WeaponFactory.weaponsId.gun, 50)
	weaponSet.getWeapon(WeaponFactory.weaponsId.gun).connect("empty", self, "_on_weapon_empty")
	_muzzle = muzzle
	_drone = drone
	animation.play("move")

func _process(_delta : float) -> void:
	flip()

func flip() -> void:
	scale.x = 1 if _drone.velocity.x < 0 else -1

func playDeath(duration : float = 1.0) -> void:
	animation.play("explode", -1, 1.0 / duration)

func _on_animation_finished(animationName : String) -> void:
	if animationName != "explode":
		animation.play("move")

func _on_shoot() -> void:
	animation.play("fire")
