extends HBoxContainer

class_name WeaponBar

var _weaponSlotNode : PackedScene = preload("res://source/hud/elements/WeaponSlot.tscn")
var _weaponSet : WeaponSet

func get_class() -> String:
	return "WeaponBar"

func initialize(weaponSet : WeaponSet) -> void:
	_weaponSet = weaponSet
	_weaponSet.connect("weaponAdded", self, "_addWeaponSlot")
	for weapon in _weaponSet.get_children():
		_addWeaponSlot(weapon)

func _addWeaponSlot(weapon : Weapon) -> void:
	var weaponSlot : WeaponSlot = _weaponSlotNode.instance()
	add_child(weaponSlot)
	weaponSlot.setTexture(weapon.name)
	weaponSlot.name = weapon.name
	weaponSlot.updateAmmoCount(weapon.getAmmo())
	weapon.connect("ammo_gained", self, "_updateWeaponSlot", [weapon])
	weapon.connect("shoot", self, "_updateWeaponSlot", [weapon])

func _updateWeaponSlot(weapon : Weapon) -> void:
	get_node(weapon.name).updateAmmoCount(weapon.getAmmo())
