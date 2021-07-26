extends KinematicBody2D

signal death()

enum DIRECTION { 	LEFT = -1,
					UNDEFINED = 0,
					RIGHT = 1 }

var velocity : Vector2 = Vector2.ZERO
var target : Actor = null
var faceDirection : int = DIRECTION.RIGHT
var stats : ActorStats
# TEMPORARY BEFORE EXPORT FEATURE GODOT 4.0
export var baseHealth : float = 100
export var baseSpeed : float = 400
export var maxHealth : float = 100
export var maxSpeed : float = 500
#
export (WeaponFactory.weaponsId) var weaponEquiped

onready var sm : StateMachine = $StateMachine
onready var label : Label = $Label
onready var weaponSet : WeaponSet = $WeaponSet
onready var muzzle : Position2D = $Muzzle
onready var sensor : SensorPlatform = $SensorPlatform

func setup(target : Actor, projectileStore : Node) -> void:
	self.target = target
	setProjectileStore(projectileStore)
	setStats()

func activate(b : bool) -> void:
	set_physics_process(b)
	set_process_input(b)
	set_process_unhandled_key_input(b)
	set_process_unhandled_input(b)
	sm.activate(b)

func setStats() -> void:
	var health : Attribute = Attribute.new(baseHealth, 0, maxHealth)
	var runSpeed : Attribute = Attribute.new(baseSpeed, 0, maxSpeed)
	stats = ActorStats.new(health, runSpeed)
	stats.health.connect("valueChanged", self, "_on_health_changed")

func setProjectileStore(projectileStore : Node) -> void:
	weaponSet.setup(projectileStore, muzzle, self)
	setWeapons()

func setWeapons() -> void:
	weaponSet.addWeapon(weaponEquiped, 50)

func _on_health_changed(value : float) -> void:
	if value < 0.1:
		emit_signal("death")
#############
func endureGravity(delta : float) -> void:
	velocity.y += WorldInfo.GRAVITY * delta

func preventSinkingIntoWall() -> void:
	var maxVelocityIntoWall : float = 150.0
	velocity.x = clamp(velocity.x, -maxVelocityIntoWall, maxVelocityIntoWall)

func preventSinkingIntoFloor() -> void:
	velocity.y = min(velocity.y, 0)

func preventSinkingIntoCeilling() -> void:
	velocity.y = max(velocity.y, 0)
