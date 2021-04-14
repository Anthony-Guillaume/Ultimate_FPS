extends Sprite

class_name ExplosionAnimation001

onready var animation : AnimationPlayer = $AnimationPlayer

func get_class() -> String:
	return "ExplosionAnimation001"

func play(duration : float = 1.0) -> void:
	animation.connect("animation_finished", self, "_on_animation_finished")
	animation.play("explode", -1, 1.0 / duration)

func _on_animation_finished(_animationName : String) -> void:
	pass
