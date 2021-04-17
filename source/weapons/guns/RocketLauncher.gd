extends Weapon

class_name RocketLauncher

func get_class() -> String:
	return "RocketLauncher"

func _init() -> void:
	cooldown = 0.8
	_projectileScene = preload("res://source/weapons/projectiles/objects/Rocket.tscn")
