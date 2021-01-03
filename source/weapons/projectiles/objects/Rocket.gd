extends Projectile

class_name Rocket

func get_class() -> String:
	return "Rocket"

func _init() -> void:
	speed = 700

func _on_body_entered(target) -> void:
	var explosion : Explosion = load("res://source/weapons/projectiles/objects/Explosion.tscn").instance()
	explosion.global_position = global_position
	get_parent().call_deferred("add_child", explosion)
	queue_free()
