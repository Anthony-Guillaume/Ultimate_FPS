extends BaseAi

class_name Turret

var rotationSpeed : float = 1.5
var muzzleDistance : float = 80.0
var reloadDuration : float = 2.5

onready var top : Sprite = $Top
onready var timer : Timer = $Timer

func get_class() -> String:
	return "Turret"

func _ready() -> void:
	weaponSet.getWeapons()[0].connect("empty", self, "_on_weapon_empty")
	var states : Dictionary = { "WATCHING" : State.new(self, "", "", "handleWatching"),
								"COMBATTING" : State.new(self, "", "", "handleCombatting"),
								"RELOADING" : State.new(self, "", "", "handleReloading"),
								"DEATH" : State.new(self, "onStartDeath", "onEndDeath", "handleDeath")}
	sm.setStates(states)
	sm.startWithState("WATCHING")

func _process(_delta : float) -> void:
	label.set_text(sm.getCurrentState())

###############################################################
##### STATE HANDLERS
###############################################################

func handleWatching(delta : float) -> void:
	smoothRotationTo(global_position + Vector2.RIGHT * 1000, delta)
	if player.global_position.distance_to(global_position) < 200.0:
		sm.changeState("COMBATTING")

###############################################################

func handleCombatting(delta : float) -> void:
	if player.global_position.distance_to(global_position) > 200.0:
		sm.changeState("WATCHING")
	else:
		smoothRotationTo(player.global_position, delta)
		fire()

###############################################################

func handleReloading(_delta : float) -> void:
	if is_zero_approx(timer.get_time_left()):
		sm.changeState("WATCHING")

###############################################################

func handleDeath(_delta : float) -> void:
	if is_zero_approx(timer.get_time_left()):
		sm.end()
		emit_signal("death")

func onStartDeath() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	var deathDuration : float = 0.5
	# $animation.playDeath(deathDuration)
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
	if abs(top.get_angle_to(player.global_position)) < PI * 0.3:
		weaponSet.fire()

func smoothRotationTo(target : Vector2, delta : float) -> void:
	muzzle.position = Vector2.ZERO
	if abs(muzzle.get_angle_to(target)) < PI * 0.05:
		muzzle.position += muzzle.transform.x * muzzleDistance
		return
	if muzzle.get_angle_to(target) > 0:
		rotateMuzzle(rotationSpeed * delta)
	else:
		rotateMuzzle(-rotationSpeed * delta)

func rotateMuzzle(angle : float) -> void:
	muzzle.rotate(angle)
	muzzle.position += muzzle.transform.x * muzzleDistance
	top.rotate(angle)
