extends Area2D

class_name Explosion

var damage : float = 100.0
var radius : float = 100.0
var knockbackForce : float = 500.0
var duration : float = 0.31

var targets : Array = []

onready var sfx : Sfx = $Sfx
onready var raycast : RayCast2D = $RayCast2D
onready var animation : Sprite = $Animation
onready var timer : Timer = $Timer

func get_class() -> String:
	return "Explosion"

func _ready() -> void:
	$CollisionShape2D.shape.radius = radius
	connect("body_entered", self, "_on_body_entered")
	timer.connect("timeout", self, "_on_timer_timeout")
	sfx.play()
	animation.play(duration)
	timer.start(duration)

func _on_body_entered(target) -> void:
	if targets.has(target) or target.get_collision_layer() == WorldInfo.LAYER.PROJECTILE_BLOCKER:
		return
	targets.push_back(target)
	var impact : Vector2 = getClosestImpactPoint(target)
	ActorStatusHandler.applyKnockbackFromExplosion(target, global_position, impact, radius, knockbackForce, damage)

func getClosestImpactPoint(target) -> Vector2:
	raycast.cast_to = (target.global_position - global_position).normalized() * radius
	raycast.force_raycast_update()
	var collider : Actor = raycast.get_collider()
	while collider != null and raycast.get_collider() != target:
		collider = raycast.get_collider()
		raycast.add_exception(collider)
		raycast.force_raycast_update()
	raycast.clear_exceptions()
	return raycast.get_collision_point()

func _on_timer_timeout() -> void:
	queue_free()
