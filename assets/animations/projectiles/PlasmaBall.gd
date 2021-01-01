extends Sprite

onready var animation : AnimationPlayer = $AnimationPlayer

func play() -> void:
	animation.connect("animation_finished", self, "_on_animation_finished")
	animation.play("fire")

func _on_animation_finished(animationName : String) -> void:
	pass
