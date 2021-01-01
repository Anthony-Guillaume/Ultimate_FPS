extends Projectile

class_name PlasmaBall

func get_class() -> String:
	return "PlasmaBall"

func _init() -> void:
	damage = 20.0
	speed = 800.0

func _on_body_entered(target) -> void:
	var explosion : Explosion = load("res://source/weapons/projectiles/objects/ExplosivePlasmaBall.tscn").instance()
	explosion.global_position = global_position
	get_parent().call_deferred("add_child", explosion)
	queue_free()
