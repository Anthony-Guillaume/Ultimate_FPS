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
	else:
		_setWeaponIndex(_getNextNonEmptyWeaponIndex(weaponIndex))

func switchToPreviousWeapon() -> void:
	if _weapons.empty():
		weaponIndex = NO_WEAPON_INDEX
	else:
		_setWeaponIndex(_getPreviousNonEmptyWeaponIndex(weaponIndex))

func _getWeaponIndex() -> int:
	return weaponIndex

func _getNextNonEmptyWeaponIndex(currentIndex : int) -> int:
	for i in _weapons.size():
		currentIndex = _getNextWeaponIndex(currentIndex)
		if _weapons[currentIndex].ammo > 0:
			return currentIndex
	return NO_WEAPON_INDEX

func _getPreviousNonEmptyWeaponIndex(currentIndex : int) -> int:
	for i in _weapons.size():
		currentIndex = _getPreviousWeaponIndex(currentIndex)
		if _weapons[currentIndex].ammo > 0:
			return currentIndex
	return NO_WEAPON_INDEX

func _getNextWeaponIndex(currentIndex : int) -> int:
	if currentIndex == _weapons.size() - 1:
		return 0
	else:
		return currentIndex + 1

func _getPreviousWeaponIndex(currentIndex : int) -> int:
	if currentIndex == 0:
		return _weapons.size() - 1
	else:
		return currentIndex - 1
		currentIndex

func _setWeaponIndex(index : int) -> void:
	if index != weaponIndex:
		weaponIndex = index
		_timer.start(cooldown)
