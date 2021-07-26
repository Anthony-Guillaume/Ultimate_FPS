extends Node2D

class_name SensorPlatform

onready var leftFall : RayCast2D = $leftFall
onready var rightFall : RayCast2D = $rightFall
onready var actor : Actor = get_parent()

func get_class() -> String: 
   return "SensorPlatform"

func setup(width : float) -> void:
   leftFall.position = Vector2.LEFT * width * 1.5
   rightFall.position = Vector2.RIGHT * width * 1.5

func canFall() -> bool:
	var direction : int = actor.runDirection
	if direction == 1:
		return rightFall.is_colliding()
	elif direction == -1:
		return leftFall.is_colliding()
	else:
		return false
