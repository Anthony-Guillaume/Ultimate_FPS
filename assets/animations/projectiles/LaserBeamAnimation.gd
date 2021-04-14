extends Node2D

class_name LaserBeamAnimation

var lineWidth : float = 4.0

onready var line : Line2D = $Line2D
onready var tween : Tween = $Tween
onready var particles : Particles2D = $Particles2D

func get_class() -> String:
	return "LaserBeamAnimation"

func setup(beamLength : float, beamDuration : float) -> void:
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2.RIGHT * beamLength)
	particles.position = Vector2.RIGHT * beamLength
	particles.lifetime = beamDuration
	tweenEffect(beamDuration)

func tweenEffect(beamDuration : float) -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(line, "width", 0, lineWidth, beamDuration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
