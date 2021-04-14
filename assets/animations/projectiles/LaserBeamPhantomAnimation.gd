extends Node2D

class_name LaserBeamPhantomAnimation

onready var line : Line2D = $Line2D
onready var tween : Tween = $Tween
onready var particles : Particles2D = $Particles2D

func get_class() -> String:
	return "LaserBeamPhantomAnimation"

func setup(beamLength : float, beamWidth : float, beamDuration : float) -> void:
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2.RIGHT * beamLength)
	particles.position = Vector2.RIGHT * beamLength
	particles.lifetime = beamDuration
	tweenEffect(beamWidth, beamDuration)

func tweenEffect(beamWidth : float, beamDuration : float) -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(line, "width", 0, beamWidth, beamDuration)
	tween.interpolate_property(line, "default_color", Color(1, 0.37, 0.37, 0), Color(1, 0, 0, 1), beamDuration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
