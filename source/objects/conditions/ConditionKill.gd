extends Condition

class_name ConditionKill

export var targetPaths : Array = []
export var targetContainerPath : Array = []
var _targets : Array = []

func _ready() -> void:
	for targetPath in targetPaths:
		var target : Actor = get_node(targetPath)
		setTarget(target)
	for container in targetContainerPath:
		for target in get_node(container).get_children():
			setTarget(target)

func setTarget(target : Actor) -> void:
	target.connect("death", self, "_on_target_death", [target])
	_targets.push_back(target)

func _on_target_death(target : Actor) -> void:
	_targets.erase(target)
	if _targets.empty():
		emit_signal("reached")
