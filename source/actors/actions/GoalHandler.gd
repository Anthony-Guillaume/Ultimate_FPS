extends Node

class_name GoalHandler

var _actions : Array 
var currentActionIndex : int = 0
var _agent : Actor

func _init(agent : Actor, actions : Array ) -> void:
	_agent = agent
	_actions = actions

func get_class() -> String: 
   return "GoalHandler"

func _ready() -> void:
	for node in _actions:
		add_child(node)

func perform() -> void:
	var currentAction : Action = _actions[currentActionIndex]
	if currentAction.isInRange():
		var actionDone : bool = currentAction.perform()
		if actionDone:
			currentAction.applyPostEffects()
			currentAction.reset()
			checkNextAction()
	else:
		_agent.moveTowardPlayer()

func checkNextAction() -> void:
	currentActionIndex += 1
	if currentActionIndex == _actions.size():
		currentActionIndex = 0
	var currentAction : Action = _actions[currentActionIndex]
	if not currentAction.checkPreconditions():
		checkNextAction()
