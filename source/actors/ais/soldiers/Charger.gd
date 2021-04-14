extends Soldier

class_name Charger

func get_class() -> String:
	return "Charger"

var chargeDestination : Vector2 = Vector2.ZERO
var chargeSpeed : float = 0.0
var damage : float = 15.0
var knockbackForce : float = 1500.0

func _ready() -> void:
	chargeSpeed = stats.runSpeed.getValue() * 2.5
	var states : Dictionary = { "PATROLLING" : State.new(self, "", "", "handlePatrolling"),
								"COMBATTING" : State.new(self, "onStartCharging", "onEndCharging", "handleCharging"),
								"RELOADING" : State.new(self, "", "", "handleReloading"),
								"RESTING" : State.new(self, "onStartResting", "", "handleResting"),
								"DEATH" : State.new(self, "onStartDeath", "onEndDeath", "handleDeath")}
	sm.setStates(states)
	sm.startWithState("PATROLLING")

func handleCharging(delta : float) -> void:
	velocity = global_position.direction_to(chargeDestination) * chargeSpeed
	var collisionInfo : KinematicCollision2D = move_and_collide(velocity * delta)
	if collisionInfo != null and collisionInfo.collider == player:
		applyChargeEffectOnTarget(collisionInfo.collider)
		sm.changeState("RESTING")
	elif global_position.distance_to(chargeDestination) < 10.0:
		sm.changeState("RESTING")

func onStartCharging() -> void:
	print("onStartCharging")
	chargeDestination = player.global_position

func onEndCharging() -> void:
	print("onEndCharging")
	chargeDestination = Vector2.ZERO

func handleResting(_delta : float) -> void:
	if is_zero_approx(timer.get_time_left()):
		sm.changeState("PATROLLING")
	
func onStartResting() -> void:
	timer.start(3.0)

func applyChargeEffectOnTarget(player : Actor) -> void:
	print("charge hit")
	ActorStatusHandler.applyKnockBack(player, global_position, knockbackForce, damage)
