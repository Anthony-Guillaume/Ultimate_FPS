extends Node

class_name GoalHandler

var actions : Array 
var currentActionIndex : int = 0
var _agent

func _init(agent) -> void:
	_agent = agent
	actions = [
		Leap.new(_agent),
		Wait.new(_agent),
		Shoot.new(_agent),
		Shoot.new(_agent),
		Shoot.new(_agent),
		Reload.new(_agent),
		Shoot.new(_agent),
		Shoot.new(_agent),
		Shoot.new(_agent),
	]

func get_class() -> String: 
   return "GoalHandler"

func _ready() -> void:
	for node in actions:
		add_child(node)

func perform() -> void:
	var currentAction : Action = actions[currentActionIndex]
	if currentAction.checkPreconditions():
		var actionDone : bool = currentAction.perform()
		if actionDone:
			currentAction.applyPostEffects()
			currentAction.reset()
			checkNextAction()
	else:
		_agent.moveTowardPlayer()

func checkNextAction() -> void:
	currentActionIndex += 1
	if currentActionIndex == actions.size():
		currentActionIndex = 0
	var currentAction : Action = actions[currentActionIndex]
	if not currentAction.checkPreconditions():
		checkNextAction()
