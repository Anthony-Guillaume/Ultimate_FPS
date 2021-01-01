extends Area2D

class_name AmmoBox

export var weaponName : String = ""
export var amount : int = 5
export var oneShot : bool = false
export var cooldown : float = 10.0

var _onCooldown : bool = false

onready var sfx : Sfx = $Sfx
onready var timer : Timer = $Timer

func get_class() -> String:
	return "AmmoBox"

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	timer.connect("timeout", self, "_on_timer_timeout")

func _on_body_entered(target : BasePlayer) -> void:
	if _onCooldown:
		return
	_onCooldown = true
	target.weaponSet.addAmmoByName(weaponName, amount)
	sfx.play()
	if oneShot:
		queue_free()
	else:
		timer.start(cooldown)
		hide()

func _on_timer_timeout() -> void:
	show()
	_onCooldown = false
