extends Area2D

class_name Key

signal looted()

func get_class() -> String:
	return "Key"

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body : BasePlayer) -> void:
	emit_signal("looted")
	queue_free()
