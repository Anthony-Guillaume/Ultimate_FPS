extends Area2D

class_name Door

export var targetPaths : Array = []
export var keyPaths : Array = []

var targets : Array = []
var keys : Array = []

func get_class() -> String:
	return "Door"

func _ready() -> void:
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
		print("open")
		open()

func open() -> void:
	$DoorBody/CollisionShape2D.set_deferred("disabled", true)
	$DoorBody/Sprite.hide()

func close() -> void:
	$DoorBody/CollisionShape2D.set_deferred("disabled", false)
	$DoorBody/Sprite.show()
