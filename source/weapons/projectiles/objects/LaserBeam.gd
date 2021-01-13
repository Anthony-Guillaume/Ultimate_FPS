extends Node2D

class_name LaserBeam

var damage : float = 35.0
var maxReach : float = 550.0

var _shooter = null
var targets : Array = []
var ennemyLayer : int = -1
var hitWall : bool = false
var duration : float = 0.18

onready var timer : Timer = $Timer
onready var raycast : RayCast2D = $RayCast2D
onready var hitbox : Area2D = $Hitbox

func get_class() -> String:
	return "LaserBeam"

func setup(shooter) -> void:
	_shooter = shooter
	if shooter.get_collision_layer() == WorldInfo.LAYER.PLAYER:
		ennemyLayer = WorldInfo.LAYER.AI
	else:
		ennemyLayer = WorldInfo.LAYER.PLAYER

func _ready() -> void:
	timer.connect("timeout", self, "_on_timer_timeout")
	hitbox.connect("body_entered", self, "_on_body_entered")
	raycast.cast_to *= maxReach
	var beamLength : float = computeBeamLength()
	$Hitbox/CollisionShape2D.shape.set_b(Vector2.RIGHT * beamLength)
	$Animation.setup(beamLength, duration)
	timer.start(duration)

func computeBeamLength() -> float:
	var numberOfTry : int = 12
	var length : float = maxReach
	for i in numberOfTry:
		raycast.force_raycast_update()
		if not raycast.is_colliding():
			break
		var collider : Object = raycast.get_collider()
		if isCollidingWithProjectileBlocker(collider) and canPassThroughProjectileBlocker(collider):
			raycast.add_exception(collider)
		else:
			length = to_local(raycast.get_collision_point()).length()
			break
	raycast.clear_exceptions()
	return length

func isCollidingWithProjectileBlocker(collider : Object) -> bool:
	return collider.get_collision_layer_bit(WorldInfo.LAYER_BIT.PROJECTILE_BLOCKER)

func canPassThroughProjectileBlocker(projectileBlocker) -> bool:
	return projectileBlocker.isProjectileAlongBlockDirection(transform.x)

func _on_body_entered(target : Object) -> void:
	if target == _shooter or target.get_collision_layer() != ennemyLayer or targets.has(target):
		return
	targets.push_back(target)
	ActorStatusHandler.applyDamage(target, damage)

func _on_timer_timeout() -> void:
	queue_free()
