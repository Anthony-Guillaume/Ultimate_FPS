extends BaseAi

"""
Animation : pour prévenir du tir de rocket iminent le mettre sur un genoux PUIS tirer
"""

class_name Soldier

var muzzleDistance : float = 80.0
var reloadDuration : float = 1.3

onready var timer : Timer = $Timer

func get_class() -> String:
	return "Soldier"

func _ready() -> void:
	var states : Dictionary = { "PATROLLING" : State.new(self, "", "", "handlePatrolling"),
								"COMBATTING" : State.new(self, "", "", "handleCombatting"),
								"RELOADING" : State.new(self, "", "", "handleReloading"),
								"DEATH" : State.new(self, "onStartDeath", "onEndDeath", "handleDeath")}
	sm.setStates(states)
	sm.startWithState("PATROLLING")

func setWeapons() -> void:
	weaponSet.addWeapon(WeaponFactory.weaponsId.gun, 50)
	weaponSet.getWeapon(WeaponFactory.weaponsId.gun).connect("empty", self, "_on_weapon_empty")

func _process(_delta : float) -> void:
	label.set_text(sm.getCurrentState())

###############################################################
##### STATE HANDLERS
###############################################################

func handlePatrolling(delta : float) -> void:
	patrol()
	if player.global_position.distance_to(global_position) < meleeReach:
		sm.changeState("COMBATTING")
		stand()
	endureGravity(delta)
	move_and_slide(velocity, Vector2.UP)

###############################################################

func handleCombatting(delta : float) -> void:
	if player.global_position.distance_to(global_position) > meleeReach:
		sm.changeState("PATROLLING")
	else:
		rotateMuzzle(player.global_position)
		fire()
	endureGravity(delta)
	move_and_slide(velocity, Vector2.UP)

###############################################################

func handleReloading(delta : float) -> void:
	if is_zero_approx(timer.get_time_left()):
		sm.changeState("PATROLLING")
	endureGravity(delta)
	move_and_slide(velocity, Vector2.UP)

###############################################################

func handleDeath(_delta : float) -> void:
	if is_zero_approx(timer.get_time_left()):
		sm.end()
		emit_signal("death")

func onStartDeath() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	var deathDuration : float = 0.7
	# $animation.playDeath(deathDuration)
	timer.start(deathDuration)

func onEndDeath() -> void:
	emit_signal("death")

###############################################################
###############################################################

func _on_health_changed(value : float) -> void:
	if value < 0.1:
		sm.changeState("DEATH")

func _on_weapon_empty() -> void:
	timer.start(reloadDuration)
	sm.changeState("RELOADING")
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
