extends BaseAi

class_name StickyAi

var muzzleDistance : float = 80.0
var reloadDuration : float = 1.8
var direction : Vector2 = Vector2.ZERO


onready var timer : Timer = $Timer
#onready var animation : Node2D = $DroneAnimation


func get_class() -> String:
	return "StickyAi"

export var sens : int = 1
var rotating: int = 0
var directionAlongFloor = Vector2.RIGHT

onready var radius : float = $CollisionShape2D.shape.radius

func _physics_process(delta : float) -> void:
	moveAlongFloor(delta)

func moveAlongFloor(delta : float) -> void:
	if rotating > 0:
		rotation = lerp_angle(rotation, directionAlongFloor.angle(), 0.1)
		rotating -= 1
		return
	var collisionInfo : KinematicCollision2D = move_and_collide(directionAlongFloor * stats.runSpeed.getValue() * delta * sens)
	if collisionInfo != null and collisionInfo.normal.rotated(PI * 0.5).dot(directionAlongFloor) < 0.5:
		rotating = 4
		directionAlongFloor = collisionInfo.normal.rotated(PI * 0.5)
		return
	var pos : Vector2 = position
	collisionInfo = move_and_collide(directionAlongFloor.rotated(PI * 0.5) * radius)
	if collisionInfo == null:
		for i in 10:
			position = pos
			rotate(PI/32)
			directionAlongFloor = directionAlongFloor.rotated(PI/32)
			collisionInfo = move_and_collide(directionAlongFloor.rotated(PI * 0.5) * radius)
			if collisionInfo != null:
				directionAlongFloor = collisionInfo.normal.rotated(PI * 0.5)
				rotation = directionAlongFloor.angle()
				break
	else:
		directionAlongFloor = collisionInfo.normal.rotated(PI * 0.5)
		rotation = directionAlongFloor.angle()
