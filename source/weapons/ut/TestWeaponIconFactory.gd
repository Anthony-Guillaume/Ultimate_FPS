extends "res://addons/gut/test.gd"

var sut : WeaponIconFactory = null

func before_each() -> void:
   sut = WeaponIconFactory.new()

func test_build_valid_weapon() -> void:
   var validWeaponId : int = WeaponFactory.weaponsId.gun
   var _icon = sut.build(validWeaponId)
   pass_test("Shall not throw")