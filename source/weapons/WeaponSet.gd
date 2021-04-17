extends Node2D

class_name WeaponSet

signal weaponAdded(weapon, weaponId, ammo)

const NO_WEAPON_INDEX : int = -1

var _projectileStore : Node = null
var _muzzle : Muzzle
var _shooter 

onready var _weapons : Node2D = $Weapons
onready var _weaponSelector : WeaponSelector = $WeaponSelector

func get_class() -> String:
	return "WeaponSet"

func _ready() -> void:
	_weaponSelector.setup(_weapons.get_children())

func setProjectileStore(projectileStore : Node, muzzle : Muzzle, shooter) -> void:
	_projectileStore = projectileStore
	_muzzle = muzzle
	_shooter = shooter
	for weapon in _weapons.get_children():
		weapon.setProjectileStore(projectileStore, muzzle, shooter)

func getWeapons() -> Array:
	return _weapons.get_children()

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
	for node in _weapons.get_children():
		if node.name == nodeNameExpected:
			return true
	return false

func switchToNextWeapon() -> void:
	_weaponSelector.switchToNextWeapon()

func switchToPreviousWeapon() -> void:
	_weaponSelector.switchToPreviousWeapon()

func _addNewWeapon(weaponId : int, startingAmmo : int) -> void:
	var weapon : Weapon = WeaponFactory.new().build(weaponId)
	weapon.setProjectileStore(_projectileStore, _muzzle, _shooter)
	weapon.ammo = startingAmmo
	weapon.name = str(weaponId)
	_weapons.add_child(weapon)
	emit_signal("weaponAdded", weapon, weaponId, startingAmmo)
	_weaponSelector.setup(_weapons.get_children())

func _getWeaponNode(weaponId : int) -> Node:
	return _weapons.get_node(str(weaponId))
