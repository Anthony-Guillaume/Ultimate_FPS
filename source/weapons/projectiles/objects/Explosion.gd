extends Area2D

class_name Explosion

var damage : float = 100.0
var radius : float = 100.0
var knockbackForce : float = 600.0
var duration : float = 1.0

onready var sfx : Sfx = $Sfx
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

func _on_body_entered(target : Actor) -> void:
	var spaceState : Physics2DDirectSpaceState = get_world_2d().get_direct_space_state()
	var castTo : Vector2 = target.global_position - global_position
	var collisionInfo : Dictionary = spaceState.intersect_ray(global_position, castTo, [], WorldInfo.LAYER.WORLD + WorldInfo.LAYER.AI + WorldInfo.LAYER.PLAYER)
	if not collisionInfo.empty():
		ActorStatusHandler.applyKnockbackFromExplosion(target, global_position, radius, knockbackForce, damage)

func _on_timer_timeout() -> void:
	queue_free()
