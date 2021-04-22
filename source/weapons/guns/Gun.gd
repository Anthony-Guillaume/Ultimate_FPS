extends Weapon

class_name Gun

func get_class() -> String:
	return "Gun"

func _init() -> void:
	_projectileScene = preload("res://source/weapons/projectiles/objects/PistolBall.tscn")
	cooldown = 0.6
