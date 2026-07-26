extends RigidBody3D
class_name ValueableBox

@export var value : int
var grabbable : bool = true

var gameplay_manager: GameplayManager

func _ready() -> void:
	gameplay_manager = get_tree().get_first_node_in_group("GameplayManager")
	value = randi_range(gameplay_manager.current_min_coin_value, gameplay_manager.current_max_coin_value)
