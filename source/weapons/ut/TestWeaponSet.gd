extends "res://addons/gut/test.gd"

var scene : PackedScene = preload("res://source/weapons/WeaponSet.tscn")
var sut : WeaponSet = null

var projectileStore : Node = Node.new()
var muzzle : Muzzle = Muzzle.new()
var shooter = Actor.new()

const espilonForTiming : float = 0.01

func before_each() -> void:
   sut = scene.instance()
   add_child_autofree(sut)
   sut.setup(projectileStore, muzzle, shooter)
   watch_signals(sut)

func test_add_valid_weapon() -> void:
   var weaponId : int = WeaponFactory.weaponsId.gun
   sut.addWeapon(weaponId, 10)
   assert_true(sut.has(weaponId))
   assert_eq(sut.getAmmo(weaponId), 10)

func test_add_valid_weapon_shall_emit_weaponAdded() -> void:
   var weaponId : int = WeaponFactory.weaponsId.gun
   sut.addWeapon(weaponId, 10)
   assert_signal_emitted(sut, "weaponAdded")

func test_add_weapon_already_present_shall_add_ammo() -> void:
   var weaponId : int = WeaponFactory.weaponsId.gun
   sut.addWeapon(weaponId, 5)
   sut.addWeapon(weaponId, 10)
   assert_eq(sut.getAmmo(weaponId), 15)

func test_add__weapon_shall_emit_weaponAdded_for_each_different_weapon() -> void:
   sut.addWeapon(WeaponFactory.weaponsId.gun, 10)
   sut.addWeapon(WeaponFactory.weaponsId.rocketLauncher, 10)
   assert_signal_emit_count(sut, "weaponAdded", 2)

func test_add_same_weapon_shall_emit_weaponAdded_only_first_time() -> void:
   var weaponId : int = WeaponFactory.weaponsId.gun
   sut.addWeapon(weaponId, 5)
   sut.addWeapon(weaponId, 10)
   assert_signal_emit_count(sut, "weaponAdded", 1)

func test_add_same_weapon_shall_not_duplicate_weapon() -> void:
   var weaponId : int = WeaponFactory.weaponsId.gun
   sut.addWeapon(weaponId, 10)
   sut.addWeapon(weaponId, 10)
   assert_eq(sut.getWeapons().size(), 1)

func test_add_weapons_shall_not_duplicate_weapon() -> void:
   sut.addWeapon(WeaponFactory.weaponsId.gun, 10)
   sut.addWeapon(WeaponFactory.weaponsId.gun, 10)
   sut.addWeapon(WeaponFactory.weaponsId.laserGun, 10)
   sut.addWeapon(WeaponFactory.weaponsId.laserGun, 10)
   sut.addWeapon(WeaponFactory.weaponsId.rocketLauncher, 10)
   assert_eq(sut.getWeapons().size(), 3)

func test_has_weapon_should_be_fail_if_invalid_weapon() -> void:
   var weaponId : int = WeaponFactory.weaponsId.gun
   assert_false(sut.has(weaponId))
