extends Node2D

class_name WeaponSet

signal weapon_added(weapon)
signal selected_weapon_changed(weaponId)

var _projectileStore : Node = null
var _muzzle : Muzzle
var _shooter

onready var _weaponsNode : Node2D = $Weapons
var _weapons : Dictionary = {} # weaponId <-> weapon (not null)
var currentWeapon : Weapon = null

func get_class() -> String:
	return "WeaponSet"

func setup(projectileStore : Node, muzzle : Muzzle, shooter) -> void:
	_projectileStore = projectileStore
	_muzzle = muzzle
	_shooter = shooter
	for weapon in _weapons.values():
		weapon.setup(projectileStore, muzzle, shooter)

func fire() -> void:
	if currentWeapon.canFire():
		currentWeapon.fire()

func switchToNextWeapon() -> void:
	var newId : int = WeaponSelector.switchToNextNonEmptyWeapon(currentWeapon.id, getWeapons())
	if newId != currentWeapon.id:
		currentWeapon = _weapons[newId]
		emit_signal("selected_weapon_changed", newId)

func switchToPreviousWeapon() -> void:
	var newId : int = WeaponSelector.switchToPreviousNonEmptyWeapon(currentWeapon.id, getWeapons())
	if newId != currentWeapon.id:
		currentWeapon = _weapons[newId]
		emit_signal("selected_weapon_changed", newId)

func getWeapons() -> Array:
	return _weapons.values()

func getWeapon(weaponId : int) -> Weapon:
	return _weapons[weaponId]

func addAmmo(weaponId : int, amount : int) -> void:
	getWeapon(weaponId).ammo += amount

func getAmmo(weaponId : int) -> int:
	return getWeapon(weaponId).ammo

func addWeapon(weaponId : int, startingAmmo : int) -> void:
	if has(weaponId):
		addAmmo(weaponId, startingAmmo)
	else:
		_addNewWeapon(weaponId, startingAmmo)

func removeWeapon(weaponId : int) -> void:
	var weapon : Weapon = _weapons[weaponId]
	_weapons.erase(weaponId)
	weapon.queue_free()

func has(weaponId : int) -> bool:
	return _weapons.has(weaponId)

func _addNewWeapon(weaponId : int, startingAmmo : int) -> void:
	var weapon : Weapon = WeaponFactory.new().build(weaponId)
	weapon.setup(_projectileStore, _muzzle, _shooter)
	weapon.ammo = startingAmmo
	_weapons[weaponId] = weapon
	_weaponsNode.add_child(weapon)
	emit_signal("weapon_added", weapon)
	if currentWeapon == null:
		currentWeapon = weapon
		emit_signal("selected_weapon_changed", weapon.id)
