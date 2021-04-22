extends HBoxContainer

class_name WeaponBar

var _weaponSlotNode : PackedScene = preload("res://source/hud/elements/WeaponSlot.tscn")
var _currentWeaponSlotSelected : WeaponSlot = null

func get_class() -> String:
	return "WeaponBar"

func initialize(weaponSet : WeaponSet) -> void:
	weaponSet.connect("weapon_added", self, "_addWeaponSlot")
	weaponSet.connect("selected_weapon_changed", self, "_on_selected_weapon_changed")
	for weapon in weaponSet.getWeapons():
		_addWeaponSlot(weapon)
		_currentWeaponSlotSelected = get_child(0)

func _addWeaponSlot(weapon : Weapon) -> void:
	var weaponSlot : WeaponSlot = _weaponSlotNode.instance()
	add_child(weaponSlot)
	weaponSlot.setTexture(weapon.id)
	weaponSlot.updateAmmoCount(weapon.ammo)
	weapon.connect("ammo_changed", self, "_on_ammo_changed", [weapon])
	weapon.connect("empty", self, "_on_weapon_empty", [weapon])

func _on_selected_weapon_changed(weaponId) -> void:
	if _currentWeaponSlotSelected == null:
		_currentWeaponSlotSelected = _getWeaponSlot(weaponId)
	_currentWeaponSlotSelected.modulate = Color(1, 1, 1)
	_currentWeaponSlotSelected = _getWeaponSlot(weaponId)
	_currentWeaponSlotSelected.modulate = Color(0.5, 0.5, 0.5)

func _on_ammo_changed(ammo : int, weapon : Weapon) -> void:
	var weaponSlot : WeaponSlot = _getWeaponSlot(weapon.id)
	weaponSlot.updateAmmoCount(ammo)

func _on_weapon_empty(weapon : Weapon) -> void:
	var weaponSlot : WeaponSlot = _getWeaponSlot(weapon.id)
	weaponSlot.modulate = Color(1, 0, 0)

func _getWeaponSlot(weaponId : int) -> WeaponSlot:
	for child in get_children():
		if child.weaponId == weaponId:
			return child
	return null
