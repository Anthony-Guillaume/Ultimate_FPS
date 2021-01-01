extends KinematicBody2D

class_name Actor

signal death()
signal stateChanged(newState)

const SNAP : Vector2 = Vector2(0, 10)

var velocity : Vector2 = Vector2.ZERO
var runAcceleration : float
var attackDirection : Vector2

var jumpForce : float = 300.0
var snap : Vector2 = SNAP

var stats : ActorStats

onready var weaponSet : WeaponSet = $WeaponSet
onready var muzzle : Position2D = $Muzzle

# TEMPORARY BEFORE EXPORT FEATURE GODOT 4.0
export var baseHealth : float = 100
export var baseSpeed : float = 400
export var maxHealth : float = 100
export var maxSpeed : float = 500
#

func _ready() -> void:
	setStats()

func setStats() -> void:
	var health : Attribute = Attribute.new(baseHealth, 0, maxHealth)
	var runSpeed : Attribute = Attribute.new(baseSpeed, 0, maxSpeed)
	stats = ActorStats.new(health, runSpeed)
	stats.health.connect("valueChanged", self, "_on_health_changed")
	runAcceleration = baseSpeed * 0.35

func setProjectileStore(skillStore : Node) -> void:
	weaponSet.setProjectileStore(skillStore, muzzle, self)

func _on_health_changed(value : float) -> void:
	if value < 0.1:
		emit_signal("death")

func endureGravity(delta : float) -> void:
	velocity.y += WorldInfo.GRAVITY * delta

func preventSinkingIntoWall() -> void:
	var maxVelocityIntoWall : float = 150.0
	velocity.x = clamp(velocity.x, -maxVelocityIntoWall, maxVelocityIntoWall)

func preventSinkingIntoFloor() -> void:
	velocity.y = min(velocity.y, 0)

func preventSinkingIntoCeilling() -> void:
	velocity.y = max(velocity.y, 0)
