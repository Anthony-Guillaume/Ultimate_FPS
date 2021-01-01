extends Sprite

var previousDirection : Vector2 = Vector2.RIGHT

func _process(_delta : float) -> void:
	updateDirection()

func updateDirection() -> void:
	var newDirection : Vector2 = (get_global_mouse_position() - global_position).normalized()
	set_flip_v(newDirection.dot(Vector2.RIGHT) < 0)
	rotate(previousDirection.angle_to(newDirection))
	previousDirection = newDirection
