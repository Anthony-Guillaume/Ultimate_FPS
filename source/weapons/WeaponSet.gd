extends Node2D

class_name WeaponSet

signal weapon_added(weapon)
signal selected_weapon_changed(weaponId)

const NO_WEAPON_INDEX : int = -1

var _projectileStore : Node = null
var _muzzle : Muzzle
var _shooter
var _weaponSelected : Weapon = null

onready var _weapons : Node2D = $Weapons
onready var _weaponSelector : WeaponSelector = $WeaponSelector

func get_class() -> String:
	return "WeaponSet"

func setup(projectileStore : Node, muzzle : Muzzle, shooter) -> void:
	_projectileStore = projectileStore
	_muzzle = muzzle
	_shooter = shooter
	for weapon in _weapons.get_children():
		weapon.setup(projectileStore, muzzle, shooter)
	_weaponSelector.setup(_weapons.get_children())

func getWeapons() -> Array:
	return _weapons.get_children()

func getWeapon(weaponId : int) -> Weapon:
	var nodeNameExpected : String = str(weaponId)
	return _weapons.get_node_or_null(nodeNameExpected) as Weapon

func addAmmo(weaponId : int, amount : int) -> void:
	_getWeaponNode(weaponId).ammo += amount

func getAmmo(weaponId : int) -> int:
	return _getWeaponNode(weaponId).ammo

func addWeapon(weaponId : int, startingAmmo : int) -> void:
	if has(weaponId):
		addAmmo(weaponId, startingAmmo)
	else:
		_addNewWeapon(weaponId, startingAmmo)

func fire() -> void:
	if _weaponSelector.canFire():
		_weapons.get_child(_weaponSelector.weaponIndex).fire()

func has(weaponId : int) -> bool:
	var nodeNameExpected : String = str(weaponId)
	return _weapons.has_node(nodeNameExpected)

func switchToNextWeapon() -> void:
	_weaponSelector.switchToNextWeapon()
	var weaponId : int = int(_weapons.get_child(_weaponSelector.weaponIndex).name)
	emit_signal("selected_weapon_changed", weaponId)

func switchToPreviousWeapon() -> void:
	_weaponSelector.switchToPreviousWeapon()
	var weaponId : int = int(_weapons.get_child(_weaponSelector.weaponIndex).name)
	emit_signal("selected_weapon_changed", weaponId)

func _addNewWeapon(weaponId : int, startingAmmo : int) -> void:
	var weapon : Weapon = WeaponFactory.new().build(weaponId)
	weapon.setup(_projectileStore, _muzzle, _shooter)
	weapon.ammo = startingAmmo
	weapon.name = str(weaponId)
	_weapons.add_child(weapon)
	emit_signal("weapon_added", weapon)
	_weaponSelector.setup(_weapons.get_children())

func _getWeaponNode(weaponId : int) -> Node:
	return _weapons.get_node(str(weaponId))
