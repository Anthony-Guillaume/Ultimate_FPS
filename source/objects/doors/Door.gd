extends StaticBody2D

class_name Door

export var opened : bool = false
onready var _collisionShape : CollisionShape2D = $CollisionShape2D
onready var _animation : Sprite = $Animation

func get_class() -> String:
	return "Door"

func _ready() -> void:
	if opened:
		open()
	else:
		close()

func open() -> void:
	_collisionShape.set_deferred("disabled", true)
	_animation.playExtinction(0.4)
	opened = true

func close() -> void:
	_collisionShape.set_deferred("disabled", false)
	_animation.playIgnition()
	opened = false
