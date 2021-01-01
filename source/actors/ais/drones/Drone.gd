extends BaseAi

class_name Drone

var muzzleDistance : float = 80.0
var reloadDuration : float = 1.8

onready var timer : Timer = $Timer
onready var animation : Node2D = $DroneAnimation

func get_class() -> String:
	return "Drone"

func _ready() -> void:
	weaponSet.get_child(0).connect("empty", self, "_on_weapon_empty")
	states = { 	"PATROLLING" : "handlePatrolling",
				"COMBATTING" : "handleCombatting",
				"RELOADING" : "handleReloading"}
	changeStateTo("PATROLLING")
	animation.setup(self, weaponSet, muzzle)

func _process(_delta : float) -> void:
	label.set_text(str(states[state]))

func _physics_process(delta : float) -> void:
	stateHandler.call_func(delta)
	move_and_slide(velocity)

func handlePatrolling(delta : float) -> void:
	patrol()
	if player.global_position.distance_to(global_position) < sightDistance:
		changeStateTo("COMBATTING")
		stand()

func handleCombatting(delta : float) -> void:
	if player.global_position.distance_to(global_position) > sightDistance:
		changeStateTo("PATROLLING")
	else:
		rotateMuzzle(player.global_position)
		fire()

func handleReloading(delta : float) -> void:
	if timer.get_time_left() < 0.005:
		changeStateTo("PATROLLING")

func _on_weapon_empty() -> void:
	timer.start(reloadDuration)
	changeStateTo("RELOADING")
	weaponSet.addAmmoByIndex(0, 50)

func fire() -> void:
	weaponSet.fireByIndex(0)

func patrol() -> void:
	if is_on_wall():
		changeDirection()
	moveForward()
	rotateMuzzle(global_position + velocity)	

func rotateMuzzle(destination : Vector2) -> void:
	muzzle.position = Vector2.ZERO
	muzzle.rotation = (destination - global_position).angle()
	muzzle.position += muzzle.transform.x * muzzleDistance
