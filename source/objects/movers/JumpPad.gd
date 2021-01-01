extends Area2D

class_name JumpPad

export var bumpDirection : Vector2 = Vector2.UP
export var bumpForce : float = 1000

var _durationToBeAbleToReEnterInJumpPad : float = 0.7
var _targetsRecentlyEntered : Array = []

onready var sfx : Sfx = $Sfx

func _ready() -> void:
	connect("body_entered", self, "_bump")

func _bump(target) -> void:
	if _targetsRecentlyEntered.has(target):
		return
	sfx.play()
	_addBumpForceTo(target)
	_preventTargetToEnterInJumpPad(target)

func _addBumpForceTo(target) -> void:
	target.snap = Vector2.ZERO
	target.velocity.y = 0
	target.velocity += bumpForce * bumpDirection

func _preventTargetToEnterInJumpPad(target) -> void:
	_targetsRecentlyEntered.push_back(target)
	var timer : Timer = Timer.new()
	timer.set_one_shot(true)
	timer.connect("timeout", self, "_on_timer_timeout", [_targetsRecentlyEntered.size() - 1, timer])
	add_child(timer)
	timer.start(_durationToBeAbleToReEnterInJumpPad)

func _on_timer_timeout(index : int, timer : Timer) -> void:
	var target = _targetsRecentlyEntered[index]
	target.snap = target.SNAP
	_targetsRecentlyEntered.erase(target)
	timer.queue_free()
