extends Object

class_name WeaponFactory

enum weaponsId {gun=0, laserGun, laserGunPhantom, plasmaGun, rocketLauncher}

const _scenes : Array = [
	preload("res://source/weapons/guns/Gun.tscn"),
	preload("res://source/weapons/guns/LaserGun.tscn"),
	preload("res://source/weapons/guns/LaserGunPhantom.tscn"),
	preload("res://source/weapons/guns/PlasmaGun.tscn"),
	preload("res://source/weapons/guns/RocketLauncher.tscn")
]

func get_class() -> String: 
   return "WeaponFactory"

func build(weaponId : int) -> Weapon:
	assert(weaponId in weaponsId.values(), "weaponId is not a valid enum value")
	var weapon : Weapon = _scenes[weaponId].instance()
	return weapon
