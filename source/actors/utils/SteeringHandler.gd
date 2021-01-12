extends Reference

class_name SteeringHandler

func get_class() -> String:
	return "SteeringHandler"

func follow(velocity : Vector2, desiredDirection : Vector2, maxSpeed : float, mass : float) -> Vector2:
	var desiredVelocity : Vector2 = desiredDirection * maxSpeed
	var steering : Vector2 = (desiredVelocity - velocity) / mass
	return velocity + steering
