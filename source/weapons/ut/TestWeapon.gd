extends "res://addons/gut/test.gd"

var scene : PackedScene = preload("res://source/weapons/guns/PlasmaGun.tscn")
var sut : Weapon = null

var projectileStore : Node = Node.new()
var muzzle : Muzzle = Muzzle.new()
var shooter = Actor.new()

const espilonForTiming : float = 0.01

func before_each() -> void:
	sut = scene.instance()
	sut.setup(projectileStore, muzzle, shooter)
	add_child_autofree(sut)
	watch_signals(sut)

# GUT inconsistent with this
# func test_fire_shall_create_a_new_projectile() -> void:
#    assert_eq(projectileStore.get_child_count(), 0)
#    sut.fire()
#    assert_eq(projectileStore.get_child_count(), 1)

func test_fire_with_ammo_available_shall_emmit_shoot() -> void:
   sut.ammo = 10
   sut.fire()
   assert_eq(9, sut.ammo)
   assert_signal_emitted(sut, "shoot")

func test_fire_with_ammo_equal_1_shall_emit_empty() -> void:
   sut.ammo = 1
   sut.fire()
   assert_eq(0, sut.ammo)
   assert_signal_emitted(sut, "shoot")
   assert_signal_emitted(sut, "empty")

func test_fire_without_ammo_available_shall_not_emit_shoot() -> void:
   sut.ammo = 0
   sut.fire()
   assert_eq(0, sut.ammo)
   assert_signal_not_emitted(sut, "shoot")
   
func test_fire_after_cooldown_shall_emit_shoot() -> void:
   sut.fire()
   yield(yield_for(sut.cooldown + espilonForTiming), YIELD)
   sut.fire()
   assert_signal_emit_count(sut, "shoot", 2)

func test_fire_on_cooldown_shall_not_emit_shoot() -> void:
   sut.fire()
   sut.fire()
   assert_signal_emit_count(sut, "shoot", 1)

func test_can_fire_shall_be_true() -> void:
   sut.ammo = 1
   assert_true(sut.canFire())

func test_can_fire_shall_be_false_if_no_ammo() -> void:
   sut.ammo = 0
   assert_false(sut.canFire())

func test_can_fire_shall_be_false_if_on_cooldown() -> void:
   sut.ammo = 3
   sut.fire()
   assert_false(sut.canFire())
