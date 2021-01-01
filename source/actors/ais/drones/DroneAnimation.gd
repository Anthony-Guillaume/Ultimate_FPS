extends Node2D

class_name DroneAnimation

var _muzzle : Position2D
onready var animation : AnimationPlayer = $AnimationPlayer

func get_class() -> String:
	return "Drone"

func setup(drone : Drone, weaponSet : WeaponSet, muzzle : Position2D) -> void:
	animation.connect("animation_finished", self, "_on_animation_finished")
	weaponSet.get_child(0).connect("shoot", self, "_on_shoot")
	_muzzle = muzzle
	animation.play("move")

func _process(_delta : float) -> void:
	$Explode.set_flip_h(_muzzle.position.x > 0)
	$Fire.set_flip_h(_muzzle.position.x > 0)
	$Move.set_flip_h(_muzzle.position.x > 0)

func _on_shoot() -> void:
	animation.play("fire")

func _on_animation_finished(animationName : String) -> void:
	animation.play("move")
	
