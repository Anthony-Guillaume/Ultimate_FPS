extends Reference

class_name State

var onStart : FuncRef = null
var onExit : FuncRef = null
var physicProcess : FuncRef = null

func get_class() -> String:
	return "State"

func _init(owner : Object, onStartHandler : String, onExitHandler : String, physicProcessHandler : String) -> void:
	if onStartHandler != "":
		onStart = funcref(owner, onStartHandler)
	if onExitHandler != "":
		onExit = funcref(owner, onExitHandler)
	physicProcess = funcref(owner, physicProcessHandler)
