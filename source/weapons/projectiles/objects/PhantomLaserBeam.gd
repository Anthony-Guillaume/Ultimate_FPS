extends Node2D

class_name PhantomLaserBeam

var damage : float = 35.0
var maxReach : float = 1500.0

var _shooter = null
var targets : Array = []
var ennemyLayer : int = -1
var hitWall : bool = false
var duration : float = 0.18

onready var timer : Timer = $Timer
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
	var beamLength : float = maxReach
	$Hitbox/CollisionShape2D.shape.set_b(Vector2.RIGHT * beamLength)
	$Animation.setup(beamLength, duration)
	timer.start(duration)

func _on_timer_timeout() -> void:
	queue_free()

func _on_body_entered(target : Actor) -> void:
	if target == _shooter or targets.has(target) or target.get_collision_layer() != ennemyLayer:
		return
	targets.push_back(target)
	ActorStatusHandler.applyDamage(target, damage)
