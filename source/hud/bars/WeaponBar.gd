extends HBoxContainer

class_name WeaponBar

var _weaponSlotNode : PackedScene = preload("res://source/hud/elements/WeaponSlot.tscn")
var _weaponSet : WeaponSet

func get_class() -> String:
	return "WeaponBar"

func initialize(weaponSet : WeaponSet) -> void:
	_weaponSet = weaponSet
	_weaponSet.connect("weaponAdded", self, "_addWeaponSlot")
	for weapon in _weaponSet.getWeapons():
		# Not great, coupling with weaponSet cause need to know weaponId is weapon.name
		_addWeaponSlot(weapon, int(weapon.name), weapon.ammo)

func _addWeaponSlot(weapon : Weapon, weaponId : int, ammo : int) -> void:
	assert(weaponId in WeaponFactory.weaponsId.values(), "weaponId is not a valid enum value")
	var weaponSlot : WeaponSlot = _weaponSlotNode.instance()
	add_child(weaponSlot)
	weaponSlot.setTexture(weaponId)
	weaponSlot.name = str(weaponId)
	weaponSlot.updateAmmoCount(ammo)
	weapon.connect("ammo_changed", weaponSlot, "updateAmmoCount")
