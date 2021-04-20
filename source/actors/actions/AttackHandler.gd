extends Action

class_name AttackHandler

func get_class() -> String: 
   return "AttackHandler"

func _init(agent).(agent) -> void:
   pass

func reset() -> void:
  pass

func _ready() -> void:
   _agent.currentWeapon.connect("shoot", self, "_on_shoot")

func checkPreconditions() -> bool:
   return _agent.currentWeapon.ammo > 0
   
func perform() -> bool:
   _agent.moveTowardsPlayer()
   return isInRange()

func isInRange() -> bool:
   return _agent.global_position.distance_to(_agent.player.global_position) < 50.0