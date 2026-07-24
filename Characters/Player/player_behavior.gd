extends RigidBody3D
class_name PlayerBehavior

@export var max_hp : float = 12
var current_hp : float

func _ready() -> void:
	current_hp = max_hp
