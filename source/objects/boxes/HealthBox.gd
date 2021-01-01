extends Area2D

class_name HealthBox

export var amount : int = 50
export var oneShot : bool = false
export var cooldown : float = 10.0

var _onCooldown : bool = false

onready var sfx : Sfx = $Sfx
onready var timer : Timer = $Timer

func get_class() -> String:
	return "HealthBox"

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	timer.connect("timeout", self, "_on_timer_timeout")

func _on_body_entered(target : BasePlayer) -> void:
	if _onCooldown:
		return
	_onCooldown = true
	var modifier : AttributeModifier = AttributeModifier.new(amount, 0)
	target.stats.addHealth(modifier)
	sfx.play()
	if oneShot:
		queue_free()
	else:
		timer.start(cooldown)
		hide()

func _on_timer_timeout() -> void:
	show()
	_onCooldown = false
