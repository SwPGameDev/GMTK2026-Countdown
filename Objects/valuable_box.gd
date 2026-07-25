extends RigidBody3D
class_name ValueableBox

@export var value : int
@export var min_value : int = 0
@export var max_value : int = 1


func _ready() -> void:
	value = randi_range(min_value, max_value)
	
