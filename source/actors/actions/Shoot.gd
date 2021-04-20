extends Action

class_name Shoot

var _hasShoot : bool = false

func get_class() -> String: 
   return "Shoot"

func _init(agent).(agent) -> void:
	pass

func reset() -> void:
	_hasShoot = false

func _ready() -> void:
	_agent.currentWeapon.connect("shoot", self, "_on_shoot")

func checkPreconditions() -> bool:
	return _agent.currentWeapon.ammo > 0
 
func perform() -> bool:
	_agent.fire()
	return _hasShoot

func _on_shoot() -> void:
	_hasShoot = true
