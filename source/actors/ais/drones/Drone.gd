extends BaseAi

class_name Drone

export var pathNode : NodePath
export var cyclycPatrolling : bool = true

var muzzleDistance : float = 80.0
var reloadDuration : float = 1.8
var direction : Vector2 = Vector2.ZERO
var navigation : Navigation2D = null
var steeringHandler : SteeringHandler = SteeringHandler.new()
var pathHandler : PathHandler = null
var combatHandler : CombatMovementHandler = CombatMovementHandler.new()

onready var timer : Timer = $Timer
onready var animation : Node2D = $DroneAnimation
onready var contextMap : ContextMap = $ContextMap


var mass : float = 8.0

func get_class() -> String:
	return "Drone"

func _ready() -> void:
	pathHandler = CyclicPathHandler.new() if cyclycPatrolling else BackAndForthPathHandler.new()
	pathHandler.pathPoints = get_node(pathNode).get_curve().get_baked_points()
	weaponSet.getWeapons()[0].connect("empty", self, "_on_weapon_empty")
	animation.setup(self, weaponSet, muzzle)
	var states : Dictionary = { "PATROLLING" : State.new(self, "onStartPatrolling", "", "handlePatrolling"),
								"COMBATTING" : State.new(self, "", "", "handleCombatting"),
								"RELOADING" : State.new(self, "", "", "handleReloading"),
								"DEATH" : State.new(self, "onStartDeath", "onEndDeath", "handleDeath")}
	sm.setStates(states)
	sm.startWithState("PATROLLING")
	velocity = Vector2(-1, 1) * stats.runSpeed.getValue()
	direction = velocity.normalized()

func _process(_delta : float) -> void:
	label.set_text(sm.getCurrentState())

###############################################################
##### STATE HANDLERS
###############################################################

func handlePatrolling(delta : float) -> void:
	followPath(delta)
	if isPlayerInsideDistance(sightDistance) and isRaycastIntersectPlayer():
		sm.changeState("COMBATTING")

func onStartPatrolling() -> void:
	pathHandler.setPathDirectionToClosestPoint(global_position)

###############################################################

func handleCombatting(delta : float) -> void:
	if isPlayerInsideDistance(sightDistance):
		rotateMuzzle(player.global_position)
		fire()
	else:
		sm.changeState("PATROLLING")
	combatMovement(delta)

###############################################################

func handleReloading(_delta : float) -> void:
	if is_zero_approx(timer.get_time_left()):
		sm.changeState("PATROLLING")
	move_and_slide(velocity)

###############################################################

func handleDeath(_delta : float) -> void:
	if is_zero_approx(timer.get_time_left()):
		sm.end()
		emit_signal("death")

func onStartDeath() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	var deathDuration : float = 0.7
	$DroneAnimation.playDeath(deathDuration)
	timer.start(deathDuration)

func onEndDeath() -> void:
	emit_signal("death")

###############################################################
###############################################################

func _on_weapon_empty() -> void:
	timer.start(reloadDuration)
	sm.changeState("RELOADING")
	weaponSet.addAmmoByIndex(0, 50)

func fire() -> void:
	weaponSet.fire()

func rotateMuzzle(destination : Vector2) -> void:
	muzzle.position = Vector2.ZERO
	muzzle.rotation = (destination - global_position).angle()
	muzzle.position += muzzle.transform.x * muzzleDistance

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

############### Patrouille, change de direction sur une collision avec un mur. Pouruis le joeur devant lui en faisant des mouvement aléatoires
## Penser à un ennemi araigné qui se suit le sol et le murs (voir scarabé hollow knight)

# func patrolReflective(delta : float) -> void:
# 	var collision : KinematicCollision2D = move_and_collide(velocity * delta)
# 	if collision != null:
# 		takeReflectiveDirection(collision.get_normal())

# func takeReflectiveDirection(normal : Vector2) -> void:
# 	direction = velocity.normalized().bounce(normal)
# 	velocity = direction * stats.runSpeed.getValue()
