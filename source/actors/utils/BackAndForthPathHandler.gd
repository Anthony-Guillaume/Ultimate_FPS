extends PathHandler

class_name BackAndForthPathHandler

var _sens : int = 1

func get_class() -> String:
	return "BackAndForthPathHandler"

func _incrementIndex() -> void:
    if _index == pathPoints.size() - 1:
        _sens = -1
    elif _index == 0:
        _sens = 1
    _index += _sens
