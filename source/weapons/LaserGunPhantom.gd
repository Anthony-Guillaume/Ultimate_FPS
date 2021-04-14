extends Weapon

class_name LaserGunPhantom

func get_class() -> String:
	return "LaserGunPhantom"

func _init() -> void:
	_cooldown = 3.0
	_projectileScene = preload("res://source/weapons/projectiles/objects/LaserBeamPhantom.tscn")
