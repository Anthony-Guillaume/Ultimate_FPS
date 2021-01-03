extends Node2D

class_name DroneAnimation

var _muzzle : Position2D
var _drone : Drone = null
onready var animation : AnimationPlayer = $AnimationPlayer

func get_class() -> String:
	return "Drone"

func setup(drone : Drone, weaponSet : WeaponSet, muzzle : Position2D) -> void:
	animation.connect("animation_finished", self, "_on_animation_finished")
	weaponSet.getWeapons()[0].connect("shoot", self, "_on_shoot")
	_muzzle = muzzle
	_drone = drone
	_drone.connect("death", self, "_on_death")
	animation.play("move")

func _process(_delta : float) -> void:
	flip()

func flip() -> void:
	scale.x = 1 if _drone.velocity.x < 0 else -1

func _on_shoot() -> void:
	animation.play("fire")

func _on_death() -> void:
	animation.play("explode")

func _on_animation_finished(animationName : String) -> void:
	animation.play("move")
