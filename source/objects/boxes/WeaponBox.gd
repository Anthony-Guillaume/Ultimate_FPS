extends Area2D

class_name WeaponBox

export (WeaponFactory.weaponsId) var weapon
export var ammo : int = 10

onready var sfx : Sfx = $Sfx

func get_class() -> String:
	return "WeaponBox"

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(target : BasePlayer) -> void:
	target.weaponSet.addWeapon(weapon, ammo)
	sfx.play()
	queue_free()
