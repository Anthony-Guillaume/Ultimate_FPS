extends Area2D

class_name Door

export var targetPaths : Array = []
export var keyPaths : Array = []
export var opened : bool = false

var targets : Array = []
var keys : Array = []

func get_class() -> String:
	return "Door"

func _ready() -> void:
	if opened:
		open()
	else:
		close()
	connect("body_entered", self, "_on_body_entered")
	for targetPath in targetPaths:
		var target : Actor = get_node(targetPath)
		target.connect("death", self, "_on_target_death", [target])
		targets.push_back(target)
	for keyPath in keyPaths:
		var key : Key = get_node(keyPath)
		key.connect("looted", self, "_on_key_death", [key])
		keys.push_back(key)

func _on_target_death(target : Actor) -> void:
	targets.erase(target)

func _on_key_death(key : Key) -> void:
	keys.erase(key)

func _on_body_entered(player : BasePlayer) -> void:
	if targets.empty() and keys.empty():
		open()

func open() -> void:
	if not opened:
		$DoorBody/LaserField.playExtinction(0.4)
		$DoorBody/CollisionShape2D.set_deferred("disabled", true)
		opened = true

func close() -> void:
	if opened:
		$DoorBody/LaserField.playIgnition()
		$DoorBody/CollisionShape2D.set_deferred("disabled", false)
		opened = false
