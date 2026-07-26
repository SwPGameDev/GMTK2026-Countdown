extends RigidBody3D
class_name ValueableBox

@export var value : int

var grabbable : bool = true

var gameplay_manger: GameplayManager

func _ready() -> void:
	gameplay_manger = %GamePlayManger
	value = randi_range(gameplay_manger.current_min_coin_value, gameplay_manger.current_max_coin_value)
