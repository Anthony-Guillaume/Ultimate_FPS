extends Sprite

class_name PlasmaBallAnimation

onready var animation : AnimationPlayer = $AnimationPlayer

func get_class() -> String:
	return "PlasmaBallAnimation"

func play() -> void:
	animation.connect("animation_finished", self, "_on_animation_finished")
	animation.play("fire")

func _on_animation_finished(animationName : String) -> void:
	pass
