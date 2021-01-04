extends Node

class_name StateMachine

signal stateChanged(stateName)

var _endState : State = State.new(self, "", "", "_handleStop")
var _states : Dictionary = {}
var _stateName : String = ""
var _state : State = _endState

func get_class() -> String:
	return "StateMachine"

func changeState(stateName : String) -> void:
	if _state.onExit != null:
		_state.onExit.call_func()
	_state = _states[stateName]
	_stateName = stateName
	if _state.onStart != null:
		_state.onStart.call_func()
	emit_signal("stateChanged", _stateName)

func startWithState(stateName : String) -> void:
	_state = _states[stateName]
	_stateName = stateName
	if _state.onExit != null:
		_state.onExit.call_func()
	emit_signal("stateChanged", _stateName)

func setStates(states : Dictionary) -> void:
	_states = states

func getCurrentState() -> String:
	return _stateName

func end() -> void:
	_state = _endState
	_stateName = "END"

func _handleStop(_delta : float) -> void:
	return

func _physics_process(delta : float) -> void:
	_state.physicProcess.call_func(delta)