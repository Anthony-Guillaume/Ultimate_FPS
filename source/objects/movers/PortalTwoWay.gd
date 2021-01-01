extends Node2D

class_name PortalTwoWay

var _bodysRecentlyEntered : Array = []
var _durationToBeAbleToReEnterInPortal : float = 1.5

onready var sfx : Sfx = $Sfx

func _ready() -> void:
	$Portal1.connect("body_entered", self, "_teleport_body_to_destination1")
	$Portal2.connect("body_entered", self, "_teleport_body_to_destination2")

func _teleport_body_to_destination1(body : Actor) -> void:
	if _bodysRecentlyEntered.has(body):
		return
	sfx.play()
	body.global_position = $Portal2.global_position
	_bodysRecentlyEntered.push_back(body)
	_preventbodyToEnterInPortal(body)

func _teleport_body_to_destination2(body : Actor) -> void:
	if _bodysRecentlyEntered.has(body):
		return
	sfx.play()
	body.global_position = $Portal1.global_position
	_bodysRecentlyEntered.push_back(body)
	_preventbodyToEnterInPortal(body)

func _preventbodyToEnterInPortal(body : Actor) -> void:
	yield(get_tree().create_timer(_durationToBeAbleToReEnterInPortal), "timeout")
	_bodysRecentlyEntered.erase(body)
