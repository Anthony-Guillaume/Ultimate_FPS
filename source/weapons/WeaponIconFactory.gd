extends Object

class_name WeaponIconFactory

const placeholder : Texture = preload("res://icon.png")

const _scenes : Array = [
	preload("res://assets/icons/plasma_icon001.png"),
	placeholder,
	preload("res://assets/icons/rocket_icon001.png"),
	placeholder,
	placeholder
]

func get_class() -> String: 
   return "WeaponIconFactory"

static func build(weaponId : int) -> Texture:
	assert(weaponId in WeaponFactory.weaponsId.values(), "weaponId is not a valid enum value")
	return _scenes[weaponId]
