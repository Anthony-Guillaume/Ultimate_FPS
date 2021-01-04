extends Weapon

class_name LaserGun

func get_class() -> String:
	return "LaserGun"

func _init() -> void:
	_cooldown = 1.2
	_projectileScene = preload("res://source/weapons/projectiles/objects/LaserBeam.tscn")
