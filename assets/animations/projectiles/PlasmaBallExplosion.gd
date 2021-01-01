extends Sprite

onready var animation : AnimationPlayer = $AnimationPlayer

func play(duration : float = 1.0) -> void:
	animation.connect("animation_finished", self, "_on_animation_finished")
	animation.play("explode", -1, 1.0 / duration)

func _on_animation_finished(_animationName : String) -> void:
	pass
