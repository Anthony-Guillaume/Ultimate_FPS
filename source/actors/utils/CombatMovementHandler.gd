extends Reference

class_name CombatMovementHandler

var distance : float = 150.0

func get_class() -> String:
	return "CombatMovementHandler"

func computeSafePoint(agentGlobalPosition : Vector2, targetGlobalPosition : Vector2) -> Vector2:
	return targetGlobalPosition.direction_to(agentGlobalPosition) * distance + targetGlobalPosition

func computePathDirection(agentGlobalPosition : Vector2, targetGlobalPosition : Vector2) -> Vector2:
	var safePoint : Vector2 = computeSafePoint(agentGlobalPosition, targetGlobalPosition)
	return agentGlobalPosition.direction_to(safePoint)
