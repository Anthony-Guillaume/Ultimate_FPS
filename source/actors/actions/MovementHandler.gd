extends Object

class_name MovementHandler

enum Direction { left=-1, none, right, }
var _agent

# 0 < x < 1
var friction : float = 0.2
var acceleration : float = 0.3

func _init(agent) -> void:
	_agent = agent

func get_class() -> String: 
   return "MovementHandler"

func move(direction : int) -> void:
	assert(direction in Direction.values(), "direction is not a valid enum value")
	if direction == Direction.none:
		_deplete()
	else:
		_run(direction)

func _run(direction : int) -> void:
	var speed : float = _agent.stats.runSpeed.getValue()
	_agent.velocity.x = lerp(_agent.velocity.x, direction * speed, acceleration)

func _deplete() -> void:
	_agent.velocity.x = lerp(_agent.velocity.x, 0, friction)
