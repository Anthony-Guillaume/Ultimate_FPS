extends PathHandler

class_name CyclicPathHandler

func get_class() -> String:
	return "CyclicPathHandler"

func _incrementIndex() -> void:
    _index += 1
    if _index == pathPoints.size():
        _index = 0
