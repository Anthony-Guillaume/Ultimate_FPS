extends Action

class_name Reload

var ammo : int = 10
var duration : float = 1.0
var _timer : Timer = Timer.new()
var _started : bool = false
var _finished : bool = false

func get_class() -> String: 
   return "Reload"

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
    return _agent.currentWeapon != null
 
func perform() -> bool:
    if not _started:
        _startReload()
        return false
    return _finished

func _startReload() -> void:
    _timer.start(duration)
    _started = true

func _on_timer_timeout() -> void:
    _agent.currentWeapon.ammo += ammo
    _finished = true