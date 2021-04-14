extends Soldier

class_name SniperMinion

signal player_spotted(position)

var emitSignalPeriod : float = 0.6
var time : float = 0.0

onready var contextMap : ContextMap = $ContextMap
var steeringHandler : SteeringHandler = SteeringHandler.new()
var pathHandler : PathHandler = CyclicPathHandler.new()
var combatHandler : CombatMovementHandler = CombatMovementHandler.new()
export var pathNode : NodePath
var mass : float = 8.0

func get_class() -> String:
	return "SniperMinion"

func _ready() -> void:
	pathHandler.pathPoints = get_node(pathNode).get_curve().get_baked_points()
	var states : Dictionary = { "PATROLLING" : State.new(self, "", "", "handlePatrolling"),
								"COMBATTING" : State.new(self, "", "", "handleCombatting"),
								# "RELOADING" : State.new(self, "", "", "handleReloading"),
								"DEATH" : State.new(self, "onStartDeath", "onEndDeath", "handleDeath")}
	sm.setStates(states)
	sm.startWithState("PATROLLING")

func _physics_process(delta : float) -> void:
	time += delta

func handlePatrolling(delta : float) -> void:
	followPath(delta)
	if isRaycastIntersectPlayer():
		sm.changeState("COMBATTING")

func handleCombatting(delta : float) -> void:
	if isRaycastIntersectPlayer():
		rotateMuzzle(player.global_position)
		fire()
		if time > emitSignalPeriod:
			sendPlayerPosition()
	else:
		sm.changeState("PATROLLING")
	combatMovement(delta)
		
func handleReloading(_delta : float) -> void:
	pass

func handleDeath(_delta : float) -> void:
	if is_zero_approx(timer.get_time_left()):
		sm.end()
		emit_signal("death")

func onStartDeath() -> void:
	var deathDuration : float = 0.7
	timer.start(deathDuration)

func onEndDeath() -> void:
	emit_signal("death")

func followPath(_delta : float) -> void:
	var desiredDirection : Vector2 = pathHandler.computePathDirection(global_position)
	var chosenDirection : Vector2 = contextMap.computeDirection(desiredDirection)
	velocity = steeringHandler.follow(velocity, chosenDirection, stats.runSpeed.getValue(), mass)
	velocity = move_and_slide(velocity)

func combatMovement(_delta : float) -> void:
	var desiredDirection : Vector2 = combatHandler.computePathDirection(global_position, player.global_position)
	var chosenDirection : Vector2 = contextMap.computeDirection(desiredDirection)
	velocity = steeringHandler.follow(velocity, chosenDirection, stats.runSpeed.getValue(), mass)
	velocity = move_and_slide(velocity)

func sendPlayerPosition() -> void:
	emit_signal("player_spotted", player.global_position)
	time = 0
