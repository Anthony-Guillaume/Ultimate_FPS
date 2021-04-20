extends Condition

class_name ConditionHasObjects

export var targetPaths : Array = []
export var actorPathNode : NodePath
var _actor : Actor
var _object : Array

func _ready() -> void:
	_actor = get_node(actorPathNode)
	for targetPath in targetPaths:
		var object : Node = get_node(targetPath)
		_object.push_back(object)

func _checkObject() -> void:
	# TODO
	emit_signal("reached")
