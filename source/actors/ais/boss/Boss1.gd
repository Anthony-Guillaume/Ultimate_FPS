extends BaseAi

class_name Boss1

var goalHandlerPhase1 : GoalHandler = GoalHandler.new(self, [
	Leap.new(self),
	Wait.new(self),
	Shoot.new(self),
	Shoot.new(self),
	Shoot.new(self),
	Reload.new(self),
	Shoot.new(self),
	Shoot.new(self),
	Shoot.new(self),
])
var goalHandlerPhase2 : GoalHandler = GoalHandler.new(self, [
	Leap.new(self),
	Wait.new(self),
	Shoot.new(self),
	Shoot.new(self),
	Shoot.new(self),
	Reload.new(self),
	Shoot.new(self),
	Shoot.new(self),
	Shoot.new(self),
])
var currentGoalHandler : GoalHandler = goalHandlerPhase1
var currentWeapon : Weapon = null
var muzzleDistance : float = 80.0
var movementHandler : MovementHandler = MovementHandler.new(self)
var direction : int = 0
var canRun : bool = true

func get_class() -> String:
	return "Boss1"

func _ready() -> void:
	
	var states : Dictionary = { 
								"PHASE1" : State.new(self, "", "", "handlePhase1"),
								"PHASE2" : State.new(self, "", "", "handlePhase2"),
								"DEATH" : State.new(self, "", "", "handleDeath")
							}
	sm.setStates(states)
	sm.startWithState("PHASE1")
	add_child(goalHandlerPhase1)
	add_child(goalHandlerPhase2)

func setWeapons() -> void:
	weaponSet.addWeapon(WeaponFactory.weaponsId.rocketLauncher, 50)
	currentWeapon = weaponSet.getWeapon(WeaponFactory.weaponsId.rocketLauncher)
	
func handlePhase1(delta : float) -> void:
	if stats.health.getValue() < stats.health.getMaxValue() * 0.5:
		sm.changeState("PHASE2")
	else:
		perform(delta)

func moveTowardPlayer() -> void:
	var dir : int = sign(player.global_position.x - global_position.x) as int
	movementHandler.move(dir)

func onStartPhase2() -> void:
	currentGoalHandler = goalHandlerPhase2

func handlePhase2(delta : float) -> void:
	perform(delta)

func perform(delta : float) -> void:
	currentGoalHandler.perform()
	if canRun:
		movementHandler.move(direction)
	endureGravity(delta)
	move_and_slide(velocity, Vector2.UP)
	label.text = str(stats.health.getValue())

func handleDeath(_delta : float) -> void:
	# if is_zero_approx(timer.get_time_left()):
	sm.end()
	emit_signal("death")

func fire() -> void:
	rotateMuzzle(player.global_position)
	weaponSet.fire()

func rotateMuzzle(destination : Vector2) -> void:
	muzzle.position = Vector2.ZERO
	muzzle.rotation = (destination - global_position).angle()
	muzzle.position += muzzle.transform.x * muzzleDistance
# func onStartDeath() -> void:
#     $CollisionShape2D.set_deferred("disabled", true)
#     var deathDuration : float = 0.7
#     # $animation.playDeath(deathDuration)
#     timer.start(deathDuration)

# func onEndDeath() -> void:
#     emit_signal("death")
