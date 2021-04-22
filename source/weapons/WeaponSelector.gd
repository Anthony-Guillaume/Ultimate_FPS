extends Node

class_name WeaponSelector

func get_class() -> String: 
   return "WeaponSelector"

const NO_WEAPON : int = -1

static func switchToNextNonEmptyWeapon(currentId : int, weapons : Array) -> int:
	if weapons.empty():
		return NO_WEAPON
	else:
		var index : int = _getCurrentIndex(currentId, weapons)
		return weapons[_getNextNonEmptyWeaponId(index, weapons)].id

static func switchToPreviousNonEmptyWeapon(currentId : int, weapons : Array) -> int:
	if weapons.empty():
		return NO_WEAPON
	else:
		var index : int = _getCurrentIndex(currentId, weapons)
		return weapons[_getPreviousNonEmptyWeaponIndex(index, weapons)].id

static func _getCurrentIndex(id : int, weapons : Array) -> int:
	for i in weapons.size():
		if weapons[i].id == id:
			return i
	return NO_WEAPON

static func _getNextNonEmptyWeaponId(currentIndex : int, weapons : Array) -> int:
# no while to avoid all weapon empty case
	for i in weapons.size():
		currentIndex = _getNextWeaponIndex(currentIndex, weapons)
		if weapons[currentIndex].ammo > 0:
			return currentIndex
	return currentIndex

static func _getPreviousNonEmptyWeaponIndex(currentIndex : int, weapons : Array) -> int:
	for i in weapons.size():
		currentIndex = _getPreviousWeaponIndex(currentIndex, weapons)
		if weapons[currentIndex].ammo > 0:
			return currentIndex
	return currentIndex

static func _getNextWeaponIndex(currentIndex : int, weapons : Array) -> int:
	if currentIndex == weapons.size() - 1:
		return 0
	else:
		return currentIndex + 1

static func _getPreviousWeaponIndex(currentIndex : int, weapons : Array) -> int:
	if currentIndex == 0:
		return weapons.size() - 1
	else:
		return currentIndex - 1
