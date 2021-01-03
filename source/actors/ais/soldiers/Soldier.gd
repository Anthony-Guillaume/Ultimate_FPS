extends BaseAi

class_name Soldier

var muzzleDistance : float = 80.0
var reloadDuration : float = 1.3

onready var timer : Timer = $Timer

func get_class() -> String:
	return "Soldier"

func _ready() -> void:
	weaponSet.getWeapons()[0].connect("empty", self, "_on_weapon_empty")
	states = { 	"PATROLLING" : "handlePatrolling",
				"COMBATTING" : "handleCombatting",
				"RELOADING" : "handleReloading"}
	changeStateTo("PATROLLING")

func _process(_delta : float) -> void:
	label.set_text(str(states[state]))

func _physics_process(delta : float) -> void:
	stateHandler.call_func(delta)
	endureGravity(delta)
	move_and_slide(velocity, Vector2.UP)

func handlePatrolling(delta : float) -> void:
	patrol()
	if player.global_position.distance_to(global_position) < meleeReach:
		changeStateTo("COMBATTING")
		stand()

func handleCombatting(delta : float) -> void:
	if player.global_position.distance_to(global_position) > meleeReach:
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
	weaponSet.fire()

func patrol() -> void:
	.patrol()
	rotateMuzzle(global_position + velocity)

func rotateMuzzle(destination : Vector2) -> void:
	muzzle.position = Vector2.ZERO
	muzzle.rotation = (destination - global_position).angle()
	muzzle.position += muzzle.transform.x * muzzleDistance
