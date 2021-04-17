extends "res://addons/gut/test.gd"

var sut : WeaponFactory = null

func before_each() -> void:
   sut = WeaponFactory.new()

func test_build_valid_weapon() -> void:
   var validWeaponId : int = WeaponFactory.weaponsId.gun
   var weapon = sut.build(validWeaponId)
   assert_eq(weapon.get_class(), "Gun")
