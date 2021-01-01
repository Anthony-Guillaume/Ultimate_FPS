extends Area2D

class_name ThrowingAxe

var damage : float = 0.0
var speed : float = 0.0
var maxDistance : float = 0.0

var _shooter = null

var _velocity : Vector2
var ennemyLayer : int = -1
var comeBacking : bool = false
var distance : float = 0.0

func get_class() -> String:
	return "ThrowingAxe"

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")

func setup(shooter) -> void:
	if shooter.get_collision_layer() == WorldInfo.LAYER.PLAYER:
		ennemyLayer = WorldInfo.LAYER.AI
	else:
		ennemyLayer = WorldInfo.LAYER.PLAYER
	var direction : Vector2 = shooter.attackDirection
	_shooter = shooter
	_velocity = direction * speed
	global_position = shooter.global_position + direction * shooter.muzzle
	rotate(direction.angle())

func _physics_process(_delta : float) -> void:
	if comeBacking:
		_backToShooter()
	global_position += _velocity
	distance += speed

func _backToShooter() -> void:
	if _shooter == null:
		queue_free()
	else:
		_velocity = global_position.direction_to(_shooter.global_position) * speed

func _on_body_entered(target) -> void:
	if comeBacking:
		if target == _shooter:
			queue_free()
		elif target.get_collision_layer() == ennemyLayer:
			ActorStatusHandler.applyDamage(_shooter.stats, target.stats, damage)
	else:
		if distance > maxDistance:
			comeBacking = true
		if target.get_collision_layer() == ennemyLayer:
			ActorStatusHandler.applyDamage(_shooter.stats, target.stats, damage)
		elif target != _shooter:
			comeBacking = true
