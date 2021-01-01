extends Node2D

class_name WeaponSet

signal weaponAdded(weapon)

var _projectileStore : Node = null
var _muzzle : Muzzle
var _shooter 

func get_class() -> String:
	return "WeaponSet"

func setProjectileStore(projectileStore : Node, muzzle : Muzzle, shooter) -> void:
	_projectileStore = projectileStore
	_muzzle = muzzle
	_shooter = shooter
	for weapon in get_children():
		weapon.setProjectileStore(projectileStore, muzzle, shooter)

func addWeapon(weaponName : String) -> void:
	var weapon : Weapon = load("res://source/weapons/" + weaponName + ".tscn").instance()
	if has(weaponName):
		addAmmoByName(weaponName, weapon.getAmmo())
	else:
		weapon.setProjectileStore(_projectileStore, _muzzle, _shooter)
		add_child(weapon)
		emit_signal("weaponAdded", weapon)

func fireByName(weaponName : String) -> void:
	get_node(weaponName).fire()

func fireByIndex(weaponIndex : int) -> void:
	get_child(weaponIndex).fire()

func has(weaponName : String) -> bool:
	return has_node(weaponName)

func addAmmoByName(weaponName : String, amount : int) -> void:
	get_node(weaponName).addAmmo(amount)

func addAmmoByIndex(weaponIndex : int, amount : int) -> void:
	get_child(weaponIndex).addAmmo(amount)
