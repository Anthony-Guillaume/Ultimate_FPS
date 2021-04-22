extends TextureRect

class_name WeaponSlot

onready var _label : Label = $Label
var weaponId : int = -1

func get_class() -> String:
	return "WeaponSlot"

func setTexture(weaponId : int) -> void:
	set_texture(WeaponIconFactory.build(weaponId))
	self.weaponId = weaponId

func updateAmmoCount(ammo : int) -> void:
	_label.set_text(str(ammo))
