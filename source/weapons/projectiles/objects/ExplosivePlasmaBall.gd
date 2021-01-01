extends Explosion

class_name ExplosivePlasmaBall

func get_class() -> String:
	return "ExplosivePlasmaBall"

func _init() -> void:
	damage = 20.0
	radius = 30.0
	knockbackForce = 50.0
	duration = 0.1
