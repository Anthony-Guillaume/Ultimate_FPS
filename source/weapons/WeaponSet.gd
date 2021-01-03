extends Node2D

class_name WeaponSet

signal weaponAdded(weapon)

const epsilon : float = 0.0001
const NO_WEAPON_INDEX : int = -1

var _projectileStore : Node = null
var _muzzle : Muzzle
var _shooter 
var _weaponIndex : int = NO_WEAPON_INDEX
var _switchWeaponCooldown : float = 0.4

onready var _weapons : Node2D = $Weapons
onready var _timer : Timer = $Timer

func get_class() -> String:
	return "WeaponSet"

func _ready() -> void:
	if _weapons.get_child_count() > 0:
		_weaponIndex = 0

func setProjectileStore(projectileStore : Node, muzzle : Muzzle, shooter) -> void:
	_projectileStore = projectileStore
	_muzzle = muzzle
	_shooter = shooter
	for weapon in _weapons.get_children():
		weapon.setProjectileStore(projectileStore, muzzle, shooter)

func getWeapons() -> Array:
	return _weapons.get_children()

func addWeapon(weaponName : String) -> void:
	var weapon : Weapon = load("res://source/weapons/" + weaponName + ".tscn").instance()
	if has(weaponName):
		addAmmoByName(weaponName, weapon.getAmmo())
	else:
		weapon.setProjectileStore(_projectileStore, _muzzle, _shooter)
		_weapons.add_child(weapon)
		emit_signal("weaponAdded", weapon)

func fire() -> void:
	if _timer.get_time_left() < epsilon and _weaponIndex != NO_WEAPON_INDEX:
		_weapons.get_child(_weaponIndex).fire()

func has(weaponName : String) -> bool:
	return has_node(weaponName)

func addAmmoByName(weaponName : String, amount : int) -> void:
	_weapons.get_node(weaponName).addAmmo(amount)

func addAmmoByIndex(weaponIndex : int, amount : int) -> void:
	_weapons.get_child(weaponIndex).addAmmo(amount)

func changeWeapon(weaponName : String) -> void:
	_setWeaponIndex(_weapons.get_node(weaponName).get_index())

func switchToNextWeapon() -> void:
	if _weaponIndex == NO_WEAPON_INDEX:
		return
	if _weaponIndex == _weapons.get_child_count() - 1:
		_setWeaponIndex(0)
	else:
		_setWeaponIndex(_weaponIndex + 1)

func switchToPreviousWeapon() -> void:
	if _weaponIndex == NO_WEAPON_INDEX:
		return
	if _weaponIndex == 0:
		_setWeaponIndex(_weapons.get_child_count() - 1)
	else:
		_setWeaponIndex(_weaponIndex - 1)

func _setWeaponIndex(index : int) -> void:
	_weaponIndex = index
	_timer.start(_switchWeaponCooldown)
