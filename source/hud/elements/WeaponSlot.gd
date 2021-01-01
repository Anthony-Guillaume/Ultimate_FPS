extends TextureRect

class_name WeaponSlot

onready var _label : Label = $Label

func get_class() -> String:
	return "WeaponSlot"

func setTexture(weaponName : String) -> void:
	match weaponName:
		"Gun":
			set_texture(load("res://assets/icons/plasma_icon001.png"))
		"RocketLauncher":
			set_texture(load("res://assets/icons/rocket_icon001.png"))
		_:
			set_texture(null)

func updateAmmoCount(ammo : int) -> void:
	_label.set_text(str(ammo))
