extends "res://addons/gut/test.gd"

var scene : PackedScene = preload("res://source/weapons/WeaponSelector.tscn")
var sut : WeaponSelector = null
const defaultAmmo : int = 5
const weaponPath : String = "res://source/weapons/Weapon.gd"
var DoubledWeapon 

const espilonForTiming : float = 0.08

func before_all() -> void:
   DoubledWeapon = double(load(weaponPath))

func before_each() -> void:
   sut = scene.instance()
   add_child_autofree(sut)

func setupWeapons(ammoArray : Array) -> void:
	var weapons : Array = []
	for ammo in ammoArray:
		var weapon = Weapon.new()
		weapon.ammo = ammo
		assert(weapon.ammo != null)
		weapons.push_back(weapon)
	WeaponSelector.setup(weapons)

func test_canFire_called_once() -> void:
   setupWeapons([defaultAmmo, defaultAmmo])
   WeaponSelector.cooldown = 0.05
   assert_true(WeaponSelector.canFire())
   WeaponSelector.switchToNextWeapon()
   assert_false(WeaponSelector.canFire())

func test_canFire_called_twice() -> void:
   setupWeapons([defaultAmmo, defaultAmmo])
   WeaponSelector.cooldown = 0.05
   assert_true(WeaponSelector.canFire())
   WeaponSelector.switchToNextWeapon()
   yield(yield_for(0.05 + espilonForTiming), YIELD)
   assert_true(WeaponSelector.canFire())

func test_switch_to_next_weapon_case_1_weapons() -> void:
   setupWeapons([defaultAmmo])
   assert_eq(WeaponSelector.weaponIndex, 0)
   WeaponSelector.switchToNextWeapon()
   assert_eq(WeaponSelector.weaponIndex, 0)
   
func test_switch_to_previous_weapon_case_1_weapons() -> void:
   setupWeapons([defaultAmmo])
   assert_eq(WeaponSelector.weaponIndex, 0)
   WeaponSelector.switchToPreviousWeapon()
   assert_eq(WeaponSelector.weaponIndex, 0)

func test_switch_to_next_weapon_case_2_weapons() -> void:
   setupWeapons([defaultAmmo, defaultAmmo])
   assert_eq(WeaponSelector.weaponIndex, 0)
   WeaponSelector.switchToNextWeapon()
   assert_eq(WeaponSelector.weaponIndex, 1)
   WeaponSelector.switchToNextWeapon()
   assert_eq(WeaponSelector.weaponIndex, 0)
   
func test_switch_to_previous_weapon_case_2_weapons() -> void:
   setupWeapons([defaultAmmo, defaultAmmo])
   assert_eq(WeaponSelector.weaponIndex, 0)
   WeaponSelector.switchToPreviousWeapon()
   assert_eq(WeaponSelector.weaponIndex, 1)
   WeaponSelector.switchToPreviousWeapon()
   assert_eq(WeaponSelector.weaponIndex, 0)

func test_switch_to_next_weapon_case_3_weapons() -> void:
   setupWeapons([defaultAmmo, defaultAmmo, defaultAmmo])
   assert_eq(WeaponSelector.weaponIndex, 0)
   WeaponSelector.switchToNextWeapon()
   assert_eq(WeaponSelector.weaponIndex, 1)
   WeaponSelector.switchToNextWeapon()
   assert_eq(WeaponSelector.weaponIndex, 2)
   WeaponSelector.switchToNextWeapon()
   assert_eq(WeaponSelector.weaponIndex, 0)
   
func test_switch_to_previous_weapon_case_3_weapons() -> void:
   setupWeapons([defaultAmmo, defaultAmmo, defaultAmmo])
   assert_eq(WeaponSelector.weaponIndex, 0)
   WeaponSelector.switchToPreviousWeapon()
   assert_eq(WeaponSelector.weaponIndex, 2)
   WeaponSelector.switchToPreviousWeapon()
   assert_eq(WeaponSelector.weaponIndex, 1)
   WeaponSelector.switchToPreviousWeapon()
   assert_eq(WeaponSelector.weaponIndex, 0)

func test_switch_to_next_weapon_shall_switch_to_first_non_empty_weapon() -> void:
   setupWeapons([defaultAmmo, 0, defaultAmmo])
   assert_eq(WeaponSelector.weaponIndex, 0)
   WeaponSelector.switchToNextWeapon()
   assert_eq(WeaponSelector.weaponIndex, 2)
   WeaponSelector.switchToNextWeapon()
   assert_eq(WeaponSelector.weaponIndex, 0)
   WeaponSelector.switchToNextWeapon()
   assert_eq(WeaponSelector.weaponIndex, 2)

func test_switch_to_previous_weapon_shall_switch_to_first_non_empty_weapon() -> void:
   setupWeapons([defaultAmmo, 0, defaultAmmo])
   assert_eq(WeaponSelector.weaponIndex, 0)
   WeaponSelector.switchToNextWeapon()
   assert_eq(WeaponSelector.weaponIndex, 2)
   WeaponSelector.switchToNextWeapon()
   assert_eq(WeaponSelector.weaponIndex, 0)
   WeaponSelector.switchToNextWeapon()
   assert_eq(WeaponSelector.weaponIndex, 2)
