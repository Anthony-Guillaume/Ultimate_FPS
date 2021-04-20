extends Area2D

class_name HurtableArea

export var damagePerTick : float = 50.0
export var period : int = 1
var _targets : Array = []

func get_class() -> String:
	return "HurtableArea"

func _ready() -> void:
	assert(period > 0)
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(target : Actor) -> void:
	if _targets.has(target):
		return
	_targets.push_back(target)
	ActorStatusHandler.applyDamage(target, damagePerTick)

func _on_body_exited(target) -> void:
	if _targets.has(target):
		_targets.erase(target)

#func _addTimer(target : Actor) -> void:
#	var timer : Timer = Timer.new()
#	timer.autostart = false
#	timer.one_shot = false
	
	
