extends Node

class_name DoorHandler

export var openDoorOnCondtionsReached : bool = true
var _conditions : Array = []
var _door : Door = null

func get_class() -> String: 
   return "DoorHandler"

func _ready() -> void:
	for child in get_children():
		if child.get_class() == "Condition":
			_conditions.push_back(child)
		else:
			_door = child
	assert(_door != null)
	_setConditions()

func _setConditions() -> void:
	for condition in _conditions:
		condition.connect("reached", self, "_on_condition_reached", [condition])

func _on_condition_reached(condition : Condition) -> void:
	_conditions.erase(condition)
	condition.queue_free()
	if _conditions.empty():
		if openDoorOnCondtionsReached:
			_door.open()
		else:
			_door.close()
