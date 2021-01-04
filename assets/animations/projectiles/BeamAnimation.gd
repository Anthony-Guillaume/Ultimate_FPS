extends Node2D

onready var line : Line2D = $Line2D
onready var lineWidth : float = line.width
onready var tween : Tween = $Tween
onready var particles : Particles2D = $Particles2D

func setup(beamLength : float, beamDuration : float) -> void:
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2.RIGHT * beamLength)
	particles.position = Vector2.RIGHT * beamLength
	particles.lifetime = beamDuration
	tweenEffect(beamDuration)

func tweenEffect(beamDuration : float) -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(line, "width", 0, lineWidth, beamDuration)
	tween.start()
