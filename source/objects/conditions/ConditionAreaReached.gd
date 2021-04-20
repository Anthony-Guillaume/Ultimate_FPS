extends Condition

class_name ConditionAreaReached

export var areaPathNode : NodePath
export var actorPathNode : NodePath
var _area : Area2D
var _actor : Actor

func _ready() -> void:
	_area = get_node(areaPathNode)
	_actor = get_node(actorPathNode)
	_area.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(_body : Actor) -> void:
	if _actor == _body:
		emit_signal("reached")

