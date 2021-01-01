extends Control

class_name HUD

onready var _healthBar : ValueBar = $HealthBar
onready var _weaponBar : WeaponBar = $WeaponBar

func _ready() -> void:
	set_as_toplevel(true)

func initialize(healthAttribute : Attribute, weaponSet : WeaponSet) -> void:
	initializeHealhBar(healthAttribute)
	_weaponBar.initialize(weaponSet)

func initializeHealhBar(healthAttribute : Attribute) -> void:
	_healthBar.initialize(int(healthAttribute.getMaxValue()), int(healthAttribute.getValue()))
	healthAttribute.connect("valueChanged", _healthBar, "updateValue")
