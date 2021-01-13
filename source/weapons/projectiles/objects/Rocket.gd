extends Projectile

class_name Rocket

var explosionScene : PackedScene = preload("res://source/weapons/projectiles/objects/Explosion.tscn")

func get_class() -> String:
	return "Rocket"

func _init() -> void:
	speed = 700

func startSelfDestruction() -> void:
	var explosion : Explosion = explosionScene.instance()
	explosion.global_position = global_position
	get_parent().call_deferred("add_child", explosion)
	queue_free()
