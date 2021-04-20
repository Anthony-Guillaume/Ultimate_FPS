extends Action

class_name Wait

var duration : float = 0.8
var _timer : Timer = Timer.new()
var _started : bool = false
var _finished : bool = false

func get_class() -> String: 
   return "Wait"

func _init(agent).(agent) -> void:
    _timer.autostart = false
    _timer.one_shot = true
    _timer.connect("timeout", self, "_on_timer_timeout")

func _ready() -> void:
    add_child(_timer)

func reset() -> void:
    _started = false
    _finished = false

func checkPreconditions() -> bool:
	return true
 
func perform() -> bool:
    if not _started:
        _startReload()
        return false
    return _finished

func _startReload() -> void:
    _timer.start(duration)
    _started = true

func _on_timer_timeout() -> void:
    _finished = true
