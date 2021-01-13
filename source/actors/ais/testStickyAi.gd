extends KinematicBody2D

export var speed : float = 100.0
export var sens : int = 1
var rotating: int = 0
var runDirection = Vector2.RIGHT

onready var radius : float = $CollisionShape2D.shape.radius

func _ready() -> void:
	assert(sens == -1 or sens == 1)

func _physics_process(delta : float) -> void:
	if rotating > 0:
		rotation = lerp_angle(rotation, runDirection.angle(), 0.1)
		rotating -= 1
		return
	var collisionInfo : KinematicCollision2D = move_and_collide(runDirection * speed * delta * sens)
	if collisionInfo != null and collisionInfo.normal.rotated(PI * 0.5).dot(runDirection) < 0.5:
		rotating = 4
		runDirection = collisionInfo.normal.rotated(PI * 0.5)
		return
	var pos : Vector2 = position
	collisionInfo = move_and_collide(runDirection.rotated(PI * 0.5) * radius)
	if collisionInfo == null:
		for i in 10:
			position = pos
			rotate(PI/32)
			runDirection = runDirection.rotated(PI/32)
			collisionInfo = move_and_collide(runDirection.rotated(PI * 0.5) * radius)
			if collisionInfo != null:
				runDirection = collisionInfo.normal.rotated(PI * 0.5)
				rotation = runDirection.angle()
				break
	else:
		runDirection = collisionInfo.normal.rotated(PI * 0.5)
		rotation = runDirection.angle()

"""
onready var rayDownLeft : RayCast2D = $RayCastDownLeft
onready var rayDownRight : RayCast2D = $RayCastDownRight
onready var rayCliff : RayCast2D = $RayCastCliff
onready var rayWall : RayCast2D = $RayCastWall
var turning : bool = false

func _physics_process(delta : float) -> void:
	var efficientSpeed : float = speed
	if not rayCliff.is_colliding():
		efficientSpeed = 150.0
		if not rayDownLeft.is_colliding() and not rayDownRight.is_colliding():
			rotate(- PI * 0.5)
	var velocity : Vector2 = transform.x * efficientSpeed * sens + transform.y * 10
	var collisionInfo : KinematicCollision2D = move_and_collide(velocity * delta)
	if collisionInfo != null:
		rotation = collisionInfo.normal.angle() + PI * 0.5

func _physics_process(_delta : float) -> void:
	var normalLeft : Vector2 = computeNormalFromRayIntersection(rayDownLeft)
	var normalRight : Vector2 = computeNormalFromRayIntersection(rayDownRight)
	var meanNormal : Vector2 = (normalLeft + normalRight).normalized()
	var velocity : Vector2 = transform.x * speed * sens + transform.y * 200
	# rotation = meanNormal.angle() + PI * 0.5
	debugNormal = meanNormal * 50
	if not rayCliff.is_colliding():
		rotation += PI * 0.007
	else:
		rotation = meanNormal.angle() + PI * 0.5
	if rayWall.is_colliding():
		rotate(- PI * 0.5)
		# rotation = lerp_angle(rotation, transform.x.angle(), 0.2)
	move_and_slide_with_snap(velocity, meanNormal * 20)
	
func computeNormalFromRayIntersection(ray : RayCast2D) -> Vector2:
	if ray.is_colliding():
		return ray.get_collision_normal()
	return Vector2.ZERO

	var velocity : Vector2 = transform.x * speed * sens + transform.y * 10
	var collisionInfo : KinematicCollision2D = move_and_collide(velocity * delta)
	if collisionInfo != null:
		rotation = collisionInfo.normal.angle() + PI * 0.5
	elif not ray.is_colliding() and not turning:
		turning = true
		rotate(PI * 0.5 * sens)
	else:
		turning = false
"""

		
