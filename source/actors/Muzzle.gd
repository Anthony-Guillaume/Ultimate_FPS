extends Position2D

class_name Muzzle

var distanceFromPlayerCenter : float = 73.0

func get_class() -> String:
	return "Muzzle"

func _physics_process(_delta : float) -> void:
	_updateMuzzle()

func _updateMuzzle() -> void:
	position = Vector2.ZERO
	rotation = (get_global_mouse_position() - global_position).angle()
	position += transform.x * distanceFromPlayerCenter
