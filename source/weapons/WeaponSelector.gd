extends Node

class_name WeaponSelector

const NO_WEAPON_INDEX : int = -1

var cooldown : float = 0.4

var weaponIndex : int = NO_WEAPON_INDEX setget , _getWeaponIndex
var _weapons : Array

onready var _timer : Timer = $Timer

func get_class() -> String: 
   return "WeaponSelector"

func setup(weapon : Array) -> void:
	_weapons = weapon
	if weapon.empty():
		weaponIndex = NO_WEAPON_INDEX
	else:
		weaponIndex = clamp(weaponIndex, 0, _weapons.size() - 1) as int

func canFire() -> bool:
	return is_zero_approx(_timer.get_time_left()) and weaponIndex != NO_WEAPON_INDEX

func switchToNextWeapon() -> void:
	if _weapons.empty():
		weaponIndex = NO_WEAPON_INDEX
		return
	if weaponIndex == _weapons.size() - 1:
		_setWeaponIndex(0)
	else:
		_setWeaponIndex(weaponIndex + 1)

func switchToPreviousWeapon() -> void:
	if _weapons.empty():
		weaponIndex = NO_WEAPON_INDEX
		return
	if weaponIndex == 0:
		_setWeaponIndex(_weapons.size() - 1)
	else:
		_setWeaponIndex(weaponIndex - 1)

func _setWeaponIndex(index : int) -> void:
	weaponIndex = index
	_timer.start(cooldown)

func _getWeaponIndex() -> int:
	return weaponIndex
