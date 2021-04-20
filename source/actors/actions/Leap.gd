extends Action

class_name Leap

var leapSpeed : float = 700.0
var leapAngle : float = deg2rad(30.0) # from x axis
var _startLeap : bool = false

func _init(agent).(agent) -> void:
   pass

func get_class() -> String: 
   return "Leap"

func reset() -> void:
   _startLeap = false

func checkPreconditions() -> bool:
   return true

func applyPostEffects() -> void:
   _agent.canRun = true

func perform() -> bool:
	if not _startLeap:
	  _setVelocityToLeap()
	  _startLeap = true
	  _agent.canRun = false
	  return false
	else:
	  return _isLeapFinished()

func _isLeapFinished() -> bool:
   return _agent.is_on_floor() and _agent.velocity.y > 5.0

func _setVelocityToLeap() -> void:
   var playerDirectionX : float = sign(_agent.player.global_position.x - _agent.global_position.x)
   _agent.velocity = Vector2.RIGHT.rotated(-leapAngle) * leapSpeed
   _agent.velocity.x *= playerDirectionX
