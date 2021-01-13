extends StaticBody2D

class_name ProjectileBlocker

var directionWhichBlockProjectile : Vector2 = Vector2.RIGHT

func get_class() -> String:
	return "ProjectileBlocker"

func isProjectileAlongBlockDirection(projectileDirection : Vector2) -> bool:
	return directionWhichBlockProjectile.dot(projectileDirection) > 0
