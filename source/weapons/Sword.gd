extends Weapon

class_name Sword

func get_class() -> String:
	return "Sword"

func _init() -> void:
	_projectileScene = preload("res://source/weapons/projectiles/objects/CutPhysics.tscn")
