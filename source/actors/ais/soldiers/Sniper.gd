extends Soldier

class_name Sniper

export var minionPath : NodePath 
var lastPlayerPosition : Vector2 = Vector2.INF

func get_class() -> String:
	return "Sniper"

func _ready() -> void:
	get_node(minionPath).connect("player_spotted", self, "_on_player_spotted_by_allies")
	var states : Dictionary = { "LISTENING" : State.new(self, "", "", "handleListening"),
								"SNIPING" : State.new(self, "", "", "handleSniping"),
								"RELOADING" : State.new(self, "", "", "handleReloading"),
								"DEATH" : State.new(self, "onStartDeath", "onEndDeath", "handleDeath")}
	sm.setStates(states)
	sm.startWithState("LISTENING")

func _on_player_spotted_by_allies(newPlayerPosition : Vector2) -> void:
	lastPlayerPosition = newPlayerPosition
	var currentState : String = sm.getCurrentState()
	if currentState == "LISTENING":
		rotateMuzzle(lastPlayerPosition)
		fire()
		lastPlayerPosition = Vector2.INF

func handleListening(_delta : float) -> void:
	if isRaycastIntersectPlayer():
		sm.changeState("SNIPING")

func handleSniping(_delta : float) -> void:
	if isRaycastIntersectPlayer():
		rotateMuzzle(player.global_position)
		fire()
	else:
		sm.changeState("LISTENING")

func handleReloading(_delta : float) -> void:
	if is_zero_approx(timer.get_time_left()):
		sm.changeState("LISTENING")

func _on_weapon_empty() -> void:
	timer.start(reloadDuration)
	sm.changeState("RELOADING")
	weaponSet.addAmmoByIndex(0, 1)
