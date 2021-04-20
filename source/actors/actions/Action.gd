extends Node

class_name Action

var _agent

func _init(agent) -> void:
	_agent = agent

func get_class() -> String: 
   return "Action"

func isInRange() -> bool:
	return true

func reset() -> void:
	pass

func checkPreconditions() -> bool:
	return true

func applyPostEffects() -> void:
	pass

func perform() -> bool:
	return true
