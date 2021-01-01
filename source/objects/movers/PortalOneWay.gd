extends Node2D

class_name PortalOneWay

func _ready() -> void:
	$Portal.connect("body_entered", self, "_teleport_player")

func _teleport_player(body : Actor) -> void:
	body.global_position = $Destination.global_position
