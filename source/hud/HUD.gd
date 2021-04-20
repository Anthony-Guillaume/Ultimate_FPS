extends Control

class_name HUD

onready var _playerHealthBar : ValueBar = $PlayerHealthBar
onready var _bossHealthBar : ValueBar = $BossHealthBar
onready var _weaponBar : WeaponBar = $WeaponBar

func _ready() -> void:
	set_as_toplevel(true)
	_bossHealthBar.hide()

func initialize(healthAttribute : Attribute, weaponSet : WeaponSet) -> void:
	_initializeHealhBar(_playerHealthBar, healthAttribute)
	_weaponBar.initialize(weaponSet)

func addBossHealthBar(healthAttribute : Attribute, boss : Actor) -> void:
	_initializeHealhBar(_bossHealthBar, healthAttribute)
	boss.connect("death", self, "_on_both_death")
	_bossHealthBar.show()

func _on_both_death() -> void:
	_bossHealthBar.hide()

func _initializeHealhBar(healthBar : ValueBar, healthAttribute : Attribute) -> void:
	healthBar.initialize(int(healthAttribute.getMaxValue()), int(healthAttribute.getValue()))
	healthAttribute.connect("valueChanged", healthBar, "updateValue")
