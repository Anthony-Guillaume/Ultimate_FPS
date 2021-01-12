extends Reference

class_name PathHandler

var pathPoints : PoolVector2Array
var threshold : float = 60.0
var _index : int = 0

func get_class() -> String:
	return "PathHandler"

func computePathDirection(globalPosition : Vector2) -> Vector2:
	if globalPosition.distance_to(pathPoints[_index]) < threshold:
		_incrementIndex()
	return (pathPoints[_index] - globalPosition).normalized()

func setPathDirectionToClosestPoint(globalPosition : Vector2) -> void:
	var distanceSquared : float = 0.0
	for i in pathPoints.size():
		var newDistanceSquared : float = globalPosition.distance_squared_to(pathPoints[i])
		if distanceSquared < newDistanceSquared:
			_index = i
			distanceSquared = newDistanceSquared

func _incrementIndex() -> void:
	pass
