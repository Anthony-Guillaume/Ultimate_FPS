extends "res://addons/gut/test.gd"

func test_build_valid_weapon() -> void:
   var validWeaponId : int = WeaponFactory.weaponsId.gun
   var _icon = WeaponIconFactory.build(validWeaponId)
   pass_test("Shall not throw")