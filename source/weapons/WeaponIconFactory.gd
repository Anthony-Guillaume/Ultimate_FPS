extends Object

class_name WeaponIconFactory

var _scenes : Array = [
	preload("res://assets/icons/plasma_icon001.png"),
	preload("res://assets/icons/rocket_icon001.png"),
	preload("res://assets/icons/rocket_icon001.png"),
	preload("res://assets/icons/rocket_icon001.png"),
	preload("res://assets/icons/rocket_icon001.png")
]

func get_class() -> String: 
   return "WeaponIconFactory"

func build(weaponId : int) -> Texture:
    assert(weaponId in WeaponFactory.weaponsId.values(), "weaponId is not a valid enum value")
    return _scenes[weaponId]