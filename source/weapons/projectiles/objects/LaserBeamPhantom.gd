extends Node2D

class_name LaserBeamPhantom

var damage : float = 35.0
var beamLength : float = 5000.0
var beamWidth : float = 30.0

var _shooter = null
var targets : Array = []
var ennemyLayer : int = -1
var duration : float = 1.1

onready var timer : Timer = $Timer
onready var hitbox : Area2D = $Hitbox
onready var hitboxShape : CollisionShape2D = $Hitbox/CollisionShape2D
onready var animation : LaserBeamPhantomAnimation = $LaserBeamPhantomAnimation

func get_class() -> String:
	return "LaserBeamPhantom"

func setup(shooter) -> void:
	_shooter = shooter
	if shooter.get_collision_layer() == WorldInfo.LAYER.PLAYER:
		ennemyLayer = WorldInfo.LAYER.AI
	else:
		ennemyLayer = WorldInfo.LAYER.PLAYER

func _ready() -> void:
	timer.connect("timeout", self, "_on_timer_timeout")
	hitbox.connect("body_entered", self, "_on_body_entered")
	hitboxShape.shape.set_extents(Vector2(beamLength, beamWidth) * 0.5)
	hitbox.position = Vector2.RIGHT * beamLength * 0.5
	animation.setup(beamLength, beamWidth, duration)
	timer.start(duration)

func _on_timer_timeout() -> void:
	queue_free()

func _on_body_entered(target) -> void:
	if timer.get_time_left() < duration * 0.5:
		return
	if target == _shooter or targets.has(target) or target.get_collision_layer() != ennemyLayer:
		return
	targets.push_back(target)
	ActorStatusHandler.applyDamage(target, damage)
