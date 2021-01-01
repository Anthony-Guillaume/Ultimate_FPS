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
	weaponSet.get_child(0).connect("empty", self, "_on_weapon_empty")
	states = { 	"WATCHING" : "handleWatching",
				"COMBATTING" : "handleCombatting",
				"RELOADING" : "handleReloading"}
	changeStateTo("WATCHING")

func _process(_delta : float) -> void:
	label.set_text(str(states[state]))

func _physics_process(delta : float) -> void:
	stateHandler.call_func(delta)

func handleWatching(delta : float) -> void:
	smoothRotationTo(global_position + Vector2.RIGHT * 1000, delta)
	if player.global_position.distance_to(global_position) < 200.0:
		changeStateTo("COMBATTING")

func handleCombatting(delta : float) -> void:
	if player.global_position.distance_to(global_position) > 200.0:
		changeStateTo("WATCHING")
	else:
		smoothRotationTo(player.global_position, delta)
		fire()

func handleReloading(delta : float) -> void:
	if timer.get_time_left() < 0.005:
		changeStateTo("WATCHING")

func _on_weapon_empty() -> void:
	timer.start(reloadDuration)
	changeStateTo("RELOADING")
	weaponSet.addAmmoByIndex(0, 50)

func fire() -> void:
	if abs(top.get_angle_to(player.global_position)) < PI * 0.3:
		weaponSet.fireByIndex(0)

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
