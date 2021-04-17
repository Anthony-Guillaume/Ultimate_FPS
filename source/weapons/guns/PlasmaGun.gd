extends Weapon

class_name PlasmaGun

func get_class() -> String:
	return "PlasmaGun"

func _init() -> void:
	cooldown = 0.3
	_projectileScene = preload("res://source/weapons/projectiles/objects/PlasmalBall.tscn")
