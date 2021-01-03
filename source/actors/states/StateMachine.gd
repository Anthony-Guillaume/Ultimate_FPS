extends Node

class_name StateMachine

var _state : State = null
var _states : Dictionary = {}

func get_class() -> String:
	return "StateMachine"

func changeState(newState : State) -> void:
	if _state.onExit != null:
		_state.onExit.call_func()
	if newState.onStart != null:
		newState.onStart.call_func()
	_state = newState

func startWithState(stateName : String) -> void:
	_state = _states[stateName]
	if _state.onExit != null:
		_state.onExit.call_func()

func setStates(states : Dictionary) -> void:
	_states = states

func _physics_process(delta : float) -> void:
	_state.physicProcess.call_func(delta)
