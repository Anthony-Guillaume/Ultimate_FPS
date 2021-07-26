extends Node

class_name StateMachine

signal stateChanged(stateName)

var _endState : State = State.new(self, "_enterEnd", "", "_handleEnd")
var _states : Dictionary = {}
var _stateName : String = ""
var _state : State = _endState

func get_class() -> String:
	return "StateMachine"

func activate(b : bool) -> void:
	set_physics_process(b)
	set_process_input(b)
	set_process_unhandled_key_input(b)
	set_process_unhandled_input(b)

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
	if _state.onStart != null:
		_state.onStart.call_func()
	set_physics_process(true)
	emit_signal("stateChanged", _stateName)	

func setStates(states : Dictionary) -> void:
	_states = states

func getCurrentState() -> String:
	return _stateName

func end() -> void:
	_state = _endState
	_stateName = "END"

func _enterEnd() -> void:
	set_physics_process(false)

func _handleEnd(_delta : float) -> void:
	return

func _physics_process(delta : float) -> void:
	_state.physicProcess.call_func(delta)
