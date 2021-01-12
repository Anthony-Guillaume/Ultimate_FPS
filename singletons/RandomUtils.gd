extends Node

var _rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
    _rng.randomize()

func computeRandomVector() -> Vector2:
    return Vector2(_rng.randf(), _rng.randf()).normalized()

func computeRandomVectorInsideCone(halfAngle : float) -> Vector2:
    """
    Axis cone is Vector.RIGHT
    """
    return Vector2.RIGHT.rotated(_rng.randf_range(-halfAngle, halfAngle))