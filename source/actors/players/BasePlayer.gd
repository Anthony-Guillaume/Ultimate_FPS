extends Actor

class_name BasePlayer

enum STATES { 	RUNNING,
				JUMPING, 
				DIVING, 
				CLIMBING,
				FALLING }

var stateHandlers : Dictionary = {	STATES.RUNNING: "handleRunningState",
									STATES.JUMPING: "handleJumpingState",
									STATES.DIVING: "handleDivingState",
									STATES.CLIMBING: "handleClimbingState",
									STATES.FALLING: "handleFallingState" }

var stateHandler : FuncRef = funcref(self, stateHandlers[STATES.RUNNING]);

enum DIRECTION { 	LEFT = -1,
					UNDEFINED = 0,
					RIGHT = 1 }

var state : int = STATES.RUNNING

var skidCoefficient : float = WorldInfo.GRAVITY * 0.2
var skidCoefficientMin : float = skidCoefficient * 0.05
var diveForce : float = 700.0
var airRunningCoefficient : float = 0.8
var wallJumpForce : Vector2 = Vector2(280, 0)
var climbSpeed : float = 450.0
var minimalVelocityToBeFalling : float = 1500.0


onready var hitboxHalfWidth : float = $CollisionShape2D.shape.get_radius()
onready var hitboxHalfHeight : float = $CollisionShape2D.shape.get_height()
onready var lengthOfRaycastClimbableDetector : float = hitboxHalfWidth + 5.0

onready var camera : Camera2D = $Camera2D
onready var hud : HUD = $CanvasLayer/HUD

# DEBUG PART
onready var labelState : Label = $Label
#

func get_class() -> String:
	return "BasePlayer"

func _ready() -> void:
	weaponSet.addWeapon(WeaponFactory.weaponsId.gun, 50)
	weaponSet.addWeapon(WeaponFactory.weaponsId.laserGun, 50)
	weaponSet.addWeapon(WeaponFactory.weaponsId.rocketLauncher, 50)
	hud.initialize(stats.health, weaponSet)
	show()

func _physics_process(delta : float) -> void:
	handleChangeWeaponInput()
	stateHandler.call_func(delta)
	move_and_slide_with_snap(velocity, snap, WorldInfo.FLOOR_NORMAL)

func hide() -> void:
	.hide()
	for child in $CanvasLayer.get_children():
		if child.has_method("hide"):
			child.hide()

func show() -> void:
	.show()
	for child in $CanvasLayer.get_children():
		if child.has_method("show"):
			child.show()

func computeWallCollisionSide() -> int:
	var spaceState : Physics2DDirectSpaceState = get_world_2d().get_direct_space_state()
	var castTo : Vector2 = global_position + Vector2.LEFT * lengthOfRaycastClimbableDetector
	var collisionInfo : Dictionary = spaceState.intersect_ray(global_position, castTo, [], WorldInfo.LAYER.CLIMBABLE)
	if not collisionInfo.empty():
		return DIRECTION.LEFT
	castTo = global_position + Vector2.RIGHT * lengthOfRaycastClimbableDetector
	collisionInfo = spaceState.intersect_ray(global_position, castTo, [], WorldInfo.LAYER.CLIMBABLE)
	if not collisionInfo.empty():
		return DIRECTION.RIGHT
	return DIRECTION.UNDEFINED

func isThereEnvironnementCollision(direction : int, height : float) -> bool:
	# height is distance between global_position and the y value to raycast (raycast supposed to be above player)
	var spaceState : Physics2DDirectSpaceState = get_world_2d().get_direct_space_state()
	var castTo : Vector2 = global_position + Vector2(hitboxHalfWidth * 3 * direction, -height)
	var collisionInfo : Dictionary = spaceState.intersect_ray(global_position, castTo, [], WorldInfo.LAYER.CLIMBABLE)
	return not collisionInfo.empty()

func canClimbOnPlatform(direction : int) -> bool:
	return (not isThereEnvironnementCollision(direction, hitboxHalfHeight * 2) and
			not isThereEnvironnementCollision(direction, hitboxHalfHeight * 3) and
			velocity.y < 5) # must be climbing up so vy < 0, epsilon = 5

func isOnClimbable(direction : int) -> bool:
	return direction != DIRECTION.UNDEFINED

func isFalling() -> bool:
	return not is_on_floor() and velocity.y > minimalVelocityToBeFalling

# STATE HANDLERS

func changeStateTo(newState : int) -> void:
	state = newState
	stateHandler.set_function(stateHandlers[newState])
	labelState.set_text(STATES.keys()[state])
	emit_signal("stateChanged", newState)

func handleRunningState(delta : float) -> void:
	snap = SNAP
	handleShootInput()
	if is_on_floor():
		handleRunInputs()
		handleJumpInput()
		preventSinkingIntoFloor()
	else:
		if velocity.y > minimalVelocityToBeFalling:
			changeStateTo(STATES.FALLING)
		elif velocity.y > 10: # epsilon
			changeStateTo(STATES.JUMPING)
	if is_on_ceiling():
		preventSinkingIntoCeilling()
	if is_on_wall():
		preventSinkingIntoWall()
	endureGravity(delta)
#	velocity = velocity.clamped(stats.runSpeed.getMaxValue())

func handleJumpingState(delta : float) -> void:
	handleShootInput()
	if is_on_wall():
		preventSinkingIntoWall()
	if is_on_ceiling():
		preventSinkingIntoCeilling()
	if is_on_floor():
		changeStateTo(STATES.RUNNING)
	else: 
		if isOnClimbable(computeWallCollisionSide()):
			changeStateTo(STATES.CLIMBING)
			velocity = Vector2.ZERO
		else:
			handleDiveAttack()
		if velocity.y > minimalVelocityToBeFalling:
			changeStateTo(STATES.FALLING)
	handleAirRunInputs()
	endureGravity(delta)

func handleDivingState(delta : float) -> void:
	if is_on_floor():
		changeStateTo(STATES.RUNNING)
	endureGravity(delta)

func handleClimbingState(delta : float) -> void:
	handleShootInput()
	var wallCollisionSide : int = computeWallCollisionSide()
	_wallSkid(wallCollisionSide, delta)
	labelState.self_modulate = Color.white
	if is_on_floor():
		changeStateTo(STATES.RUNNING)
	else:
		if canClimbOnPlatform(wallCollisionSide):
			labelState.self_modulate = Color.red
			_climbToPlatform(wallCollisionSide)
			if not is_on_wall():
				changeStateTo(STATES.RUNNING)
		elif isOnClimbable(wallCollisionSide):
			handleWallJumpInput(wallCollisionSide)
			handleClimbInput()
			handleDiveAttack()
		else:
			if velocity.y > minimalVelocityToBeFalling:
				velocity.x = 0
				changeStateTo(STATES.FALLING)
			elif velocity.y > 10: # epsilon
				velocity.x = 0
				changeStateTo(STATES.JUMPING)
			else:
				changeStateTo(STATES.JUMPING)
	
func handleFallingState(delta : float) -> void:
	if is_on_floor():
		changeStateTo(STATES.RUNNING)
	endureGravity(delta)

# INPUT HANDLERS

func handleDiveAttack() -> void:
	if Input.is_action_pressed("jump") and Input.is_action_pressed("move_down"):
		_diveAttack()
		changeStateTo(STATES.DIVING)

func handleRunInputs() -> void:
	var newDirection : int = int(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	_run(newDirection)

func handleAirRunInputs() -> void:
	var newDirection : int = int(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	_runInAir(newDirection)

func handleJumpInput() -> void:
	if Input.is_action_just_pressed("jump"):
		_jump()
		changeStateTo(STATES.JUMPING)

func handleShootInput() -> void:
	if Input.is_action_pressed("shoot"):
		_shoot()

func handleWallJumpInput(wallCollisionSide : int) -> void:
	var direction : int = int(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	if Input.is_action_just_pressed("jump") and direction == - wallCollisionSide:
		_wallJump(direction)
		changeStateTo(STATES.JUMPING)

func handleClimbInput() -> void:
	if Input.is_action_pressed("move_up"):
		_climb()

func handleChangeWeaponInput() -> void:
	if Input.is_action_just_released("next_weapon"):
		weaponSet.switchToNextWeapon()
	elif Input.is_action_just_released("previous_weapon"):
		weaponSet.switchToPreviousWeapon()

# ACTIONS

func _diveAttack() -> void:
	velocity = Vector2.DOWN * diveForce

func _run(direction : int) -> void:
	var runDirection : int = int(sign(velocity.x))
	var runSpeed : float = stats.runSpeed.getValue()
	if direction == DIRECTION.UNDEFINED:
		var runGain : float =  - velocity.x
		runGain = clamp(runGain, -runAcceleration, runAcceleration)
		velocity.x += runGain
		return
	if direction == runDirection and abs(velocity.x) > runSpeed:
		return
	var runGain : float = direction * runSpeed - velocity.x
	runGain = clamp(runGain, -runAcceleration, runAcceleration)
	velocity.x += runGain

func _runInAir(direction : int) -> void:
	var runDirection : int = int(sign(velocity.x))
	var runSpeedInAir : float = stats.runSpeed.getValue() * airRunningCoefficient
	var runAccelerationInAir : float = runAcceleration * 0.6
	if direction == DIRECTION.UNDEFINED:
		return
	if direction == runDirection and abs(velocity.x) > runSpeedInAir:
		return
	if direction != runDirection:
		var runGain : float = direction * runSpeedInAir - velocity.x
		runGain = clamp(runGain, -runAccelerationInAir, runAccelerationInAir)
		velocity.x += runGain

func _jump() -> void:
	velocity.y -= jumpForce
	snap = Vector2.ZERO

func _wallJump(direction : float) -> void:
	velocity = wallJumpForce * direction
	_jump()

func _shoot() -> void:
	weaponSet.fire()

func _wallSkid(wallCollisionSide : int, delta : float) -> void:
	var direction : int = int(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	velocity.y = max(0, velocity.y)
	if direction == wallCollisionSide:
		velocity.y += skidCoefficientMin * delta
	else:
		velocity.y += skidCoefficient * delta

func _climb() -> void:
	if velocity.y < -climbSpeed:
		return
	var climbGain : float = -climbSpeed - velocity.y
	var climbAcceleration : float = climbSpeed * 0.4
	climbGain = clamp(climbGain, -climbAcceleration, climbAcceleration)
	velocity.y += climbGain

func _climbToPlatform(platformDirection : int) -> void:
	_climb()
	var runSpeed : float = stats.runSpeed.getValue()
	if platformDirection == DIRECTION.UNDEFINED:
		platformDirection = int(sign(velocity.x))
	velocity.x = runSpeed * platformDirection
