extends Area2D

class_name WeaponBox

export var weaponName : String = ""

onready var sfx : Sfx = $Sfx

func get_class() -> String:
	return "WeaponBox"

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(target : BasePlayer) -> void:
	target.weaponSet.addWeapon(weaponName)
	sfx.play()
	queue_free()
