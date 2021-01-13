extends Area2D

class_name Projectile

var damage : float = 20.0
var speed : float = 1700.0

var _shooter = null

var _velocity : Vector2
var ennemyLayer : int = -1

func get_class() -> String:
	return "Projectile"

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")

func setup(shooter) -> void:
	if shooter.get_collision_layer() == WorldInfo.LAYER.PLAYER:
		ennemyLayer = WorldInfo.LAYER.AI
	else:
		ennemyLayer = WorldInfo.LAYER.PLAYER
	_shooter = shooter

func _physics_process(delta : float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(target : Object) -> void:
	if target == _shooter:
		return
	if target.get_collision_layer() == WorldInfo.LAYER.PROJECTILE_BLOCKER and not target.isProjectileAlongBlockDirection(transform.x):
		return
	if target.get_collision_layer() == ennemyLayer:
		ActorStatusHandler.applyDamage(target, damage)
	startSelfDestruction()

func startSelfDestruction() -> void:
	queue_free()
