extends KinematicBody2D

export var max_speed : float = 350
export var steer_force : float = 0.3
export var mass : float = 1.0
onready var path : Path2D = get_node("../Path2D")
onready var pathFollow : PathFollow2D = get_node("../Path2D/PathFollow2D")

var chosenDirection : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2.ZERO

var index : int = 0
onready var contextMap : ContextMap = $ContextMap
var steeringHandler : SteeringHandler = SteeringHandler.new()
var pathHandler : PathHandler = BackAndForthPathHandler.new()

func _ready() -> void:
	pathHandler.pathPoints = path.get_curve().get_baked_points()

func _physics_process(_delta : float) -> void:
	var desiredDirection : Vector2 = pathHandler.computePathDirection(global_position)
	chosenDirection = contextMap.computeDirection(desiredDirection)
	play()
	velocity = steeringHandler.follow(velocity, chosenDirection, max_speed, mass)
	velocity = move_and_slide(velocity)
	update()

func play() -> void:
	var force : float = 600.0
	if Input.is_action_just_pressed("move_up"):
		print("move_up")
		velocity += Vector2.UP * force
	elif Input.is_action_just_pressed("move_right"):
		print("move_right")
		velocity += Vector2.RIGHT * force
	elif Input.is_action_just_pressed("move_left"):
		print("move_left")
		velocity += Vector2.LEFT * force
	elif Input.is_action_just_pressed("move_down"):
		print("move_down")
		velocity += Vector2.DOWN * force
