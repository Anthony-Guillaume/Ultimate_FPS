extends Actor


var movementHandler : MovementHandler = MovementHandler.new(self)
export var friction : float = 0.2
export var acceleration : float = 0.3

func _ready():
	setStats()
	movementHandler.friction = friction
	movementHandler.acceleration = acceleration


func _physics_process(_delta):
	var newDirection : int = int(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	movementHandler.move(newDirection)
	move_and_slide(velocity, Vector2.UP)
	$Label.text = str(velocity.x)
