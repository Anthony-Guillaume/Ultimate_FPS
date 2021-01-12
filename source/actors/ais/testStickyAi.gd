extends KinematicBody2D

export var speed : float = 100.0
export var sens : int = 1
var rotating: int = 0
var runDirection = Vector2.RIGHT
onready var radius : float = $CollisionShape2D.shape.radius
onready var ray : RayCast2D = $RayCast2D
var turning : bool = false

func _ready() -> void:
	assert(sens == -1 or sens == 1)

func _physics_process(delta : float) -> void:
	var velocity : Vector2 = transform.x * speed * sens + transform.y * 10
	var collisionInfo : KinematicCollision2D = move_and_collide(velocity * delta)
	if collisionInfo != null:
		rotation = collisionInfo.normal.angle() + PI * 0.5
	elif not ray.is_colliding() and not turning:
		turning = true
		rotate(PI * 0.5)
	else:
		turning = false
	



"""
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
