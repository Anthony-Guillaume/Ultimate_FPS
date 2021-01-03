extends Sprite

onready var animation : AnimationPlayer = $AnimationPlayer
onready var light : Light2D = $Light2D

func _ready() -> void:
	animation.connect("animation_finished", self, "_on_animation_finished")

func playExtinction(duration : float = 1.0) -> void:
	show()
	animation.play("extinction", -1, 1.0 / duration)

func playIgnition(duration : float = 1.0) -> void:
	show()
	animation.play("ignition", -1, 1.0 / duration)

func _on_animation_finished(animationName : String) -> void:
	if animationName == "extinction":
		hide()
