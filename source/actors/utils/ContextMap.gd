extends Node2D

class_name ContextMap

export var rayLength : float = 50
export var numberOfContextRays : int = 12
export var avoidanceCoefficient : float = 1
export var polynomialCoefficient : float = 1

var _rayDirections : PoolVector2Array = PoolVector2Array()
var _interests : PoolRealArray  = PoolRealArray()
var _dangers : PoolRealArray  = PoolRealArray()

onready var agent : Node2D = get_parent()
onready var sensorStartLength : float = agent.get_node("CollisionShape2D").shape.radius
var debugDirectionWanted : Vector2

func get_class() -> String:
	return "ContextMap"

func _ready() -> void:
	_setContextMap()

func _draw() -> void:
	for i in _rayDirections.size():
		draw_line(_rayDirections[i] * sensorStartLength, _rayDirections[i] * (sensorStartLength + rayLength), Color.red, _dangers[i] * 10)
		draw_line(Vector2.ZERO, _rayDirections[i] * rayLength, Color.green, _interests[i] * 10)
	draw_line(Vector2.ZERO, agent.velocity.normalized() * 100, Color.whitesmoke, 8)
	draw_line(Vector2.ZERO, debugDirectionWanted * 100, Color.black, 8)

func _process(_delta : float) -> void:
	update()

func computeDirection(directionWanted : Vector2) -> Vector2:
	_computeDangers()
	_computeInterests(directionWanted)
	var direction : Vector2 = Vector2.ZERO
	for i in numberOfContextRays:
		if not is_zero_approx(_interests[i]):
			direction += _rayDirections[i] * (_interests[i] - _dangers[i])
	return direction.normalized()

func _setContextMap() -> void:
	_rayDirections.resize(numberOfContextRays)
	_interests.resize(numberOfContextRays)
	_dangers.resize(numberOfContextRays)
	for i in numberOfContextRays:
		var angle : float = 2 * i * PI / numberOfContextRays
		_rayDirections[i] = Vector2.RIGHT.rotated(angle)
		_interests[i] = 0
		_dangers[i] = 0

func _computeInterests(directionWanted : Vector2) -> void:
	for i in numberOfContextRays:
		_interests[i] = _computeInterest(_rayDirections[i], directionWanted)

func _computeDangers() -> void:
	var spaceState : Physics2DDirectSpaceState = agent.get_world_2d().direct_space_state
	for i in numberOfContextRays:
		_dangers[i] = _computeDanger(_rayDirections[i], spaceState)

func _computeInterest(rayDirection : Vector2, directionWanted : Vector2) -> float:
	var interest : float = rayDirection.dot(directionWanted)
	debugDirectionWanted = directionWanted
	assert(interest <= 1.000001 and interest >= -1.000001)
	return max(0, interest)

func _computeDanger(rayDirection : Vector2, spaceState : Physics2DDirectSpaceState) -> float:
	var danger : float = 0.0
	var from : Vector2 = global_position + sensorStartLength * rayDirection
	var collisionInfo : Dictionary = spaceState.intersect_ray(from, from + rayDirection * rayLength, [agent], WorldInfo.getUntraversableOjectLayer() + WorldInfo.LAYER.PLAYER + WorldInfo.LAYER.AI)
	if not collisionInfo.empty():
		var distanceToCollision : float = agent.to_local(collisionInfo["position"]).length() - sensorStartLength
		danger = _computePolynomialDanger(distanceToCollision)
	return danger * avoidanceCoefficient

func _computeLinearDanger(distanceToCollision : float) -> float:
	return 1.0 - distanceToCollision / rayLength

func _computeSquareDanger(distanceToCollision : float) -> float:
	return 1.0 - sqrt(distanceToCollision / rayLength)

func _computePolynomialDanger(distanceToCollision : float) -> float:
	return 1.0 - pow(distanceToCollision / rayLength, polynomialCoefficient)
