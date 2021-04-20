extends Node

# Purpose : spawn objects (childs) when conditions are reached ; example : portal appear when all ennemies died

class_name Spawner

var _conditions : Array = []
var _objectToSpawn : Array = []

func get_class() -> String: 
   return "Spawner"

func _ready() -> void:
	for child in get_children():
		if child.get_class() == "Condition":
			_conditions.push_back(child)
		else:
			_objectToSpawn.push_back(child)
	_setConditions()
	_removeObjectToSpawn()

func _setConditions() -> void:
	for condition in _conditions:
		condition.connect("reached", self, "_on_condition_reached", [condition])

func _removeObjectToSpawn() -> void:
	for node in _objectToSpawn:
		remove_child(node)

func _spawn() -> void:
	for node in _objectToSpawn:
		add_child(node)

func _on_condition_reached(condition : Condition) -> void:
	_conditions.erase(condition)
	condition.queue_free()
	if _conditions.empty():
		_spawn()
