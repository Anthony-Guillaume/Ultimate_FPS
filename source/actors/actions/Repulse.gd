extends Action

class_name Repulse

var reach : float = 60.0

func get_class() -> String: 
   return "Repulse"

func _init(agent).(agent) -> void:
    pass

func reset() -> void:
	pass

func checkPreconditions() -> bool:
	return abs(_agent.global_position.x - _agent.player.global_position.x) < reach
 
func perform() -> bool:
	_agent.fire()
	return true
