extends "res://addons/gut/test.gd"

var scene : PackedScene = preload("res://source/weapons/WeaponSelector.tscn")
var sut : WeaponSelector = null
var weapons : Array

const weaponPath : String = "res://source/weapons/Weapon.gd"
var DoubledWeapon 

const espilonForTiming : float = 0.08

func before_all() -> void:
   DoubledWeapon = double(load(weaponPath))

func before_each() -> void:
   sut = scene.instance()
   add_child_autofree(sut)

func test_canFire_called_once() -> void:
   weapons = [DoubledWeapon.new(), DoubledWeapon.new()]
   sut.setup(weapons)
   sut.cooldown = 0.05
   assert_true(sut.canFire())
   sut.switchToNextWeapon()
   assert_false(sut.canFire())

func test_canFire_called_twice() -> void:
   weapons = [DoubledWeapon.new(), DoubledWeapon.new()]
   sut.setup(weapons)
   sut.cooldown = 0.05
   assert_true(sut.canFire())
   sut.switchToNextWeapon()
   yield(yield_for(0.05 + espilonForTiming), YIELD)
   assert_true(sut.canFire())

func test_switch_weapon_when_no_weapon() -> void:
   weapons = []
   sut.setup(weapons)
   assert_eq(sut.weaponIndex, WeaponSelector.NO_WEAPON_INDEX)
   sut.switchToNextWeapon()
   assert_eq(sut.weaponIndex, WeaponSelector.NO_WEAPON_INDEX)
   sut.switchToPreviousWeapon()
   assert_eq(sut.weaponIndex, WeaponSelector.NO_WEAPON_INDEX)

func test_switch_to_next_weapon_case_1_weapons() -> void:
   weapons = [DoubledWeapon.new()]
   sut.setup(weapons)
   assert_eq(sut.weaponIndex, 0)
   sut.switchToNextWeapon()
   assert_eq(sut.weaponIndex, 0)
   
func test_switch_to_previous_weapon_case_1_weapons() -> void:
   weapons = [DoubledWeapon.new()]
   sut.setup(weapons)
   assert_eq(sut.weaponIndex, 0)
   sut.switchToPreviousWeapon()
   assert_eq(sut.weaponIndex, 0)

func test_switch_to_next_weapon_case_2_weapons() -> void:
   weapons = [DoubledWeapon.new(), DoubledWeapon.new()]
   sut.setup(weapons)
   assert_eq(sut.weaponIndex, 0)
   sut.switchToNextWeapon()
   assert_eq(sut.weaponIndex, 1)
   sut.switchToNextWeapon()
   assert_eq(sut.weaponIndex, 0)
   
func test_switch_to_previous_weapon_case_2_weapons() -> void:
   weapons = [DoubledWeapon.new(), DoubledWeapon.new()]
   sut.setup(weapons)
   assert_eq(sut.weaponIndex, 0)
   sut.switchToPreviousWeapon()
   assert_eq(sut.weaponIndex, 1)
   sut.switchToPreviousWeapon()
   assert_eq(sut.weaponIndex, 0)

func test_switch_to_next_weapon_case_3_weapons() -> void:
   weapons = [DoubledWeapon.new(), DoubledWeapon.new(), DoubledWeapon.new()]
   sut.setup(weapons)
   assert_eq(sut.weaponIndex, 0)
   sut.switchToNextWeapon()
   assert_eq(sut.weaponIndex, 1)
   sut.switchToNextWeapon()
   assert_eq(sut.weaponIndex, 2)
   sut.switchToNextWeapon()
   assert_eq(sut.weaponIndex, 0)
   
func test_switch_to_previous_weapon_case_3_weapons() -> void:
   weapons = [DoubledWeapon.new(), DoubledWeapon.new(), DoubledWeapon.new()]
   sut.setup(weapons)
   assert_eq(sut.weaponIndex, 0)
   sut.switchToPreviousWeapon()
   assert_eq(sut.weaponIndex, 2)
   sut.switchToPreviousWeapon()
   assert_eq(sut.weaponIndex, 1)
   sut.switchToPreviousWeapon()
   assert_eq(sut.weaponIndex, 0)
