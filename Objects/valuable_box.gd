extends RigidBody3D
class_name ValueableBox

@export var value : int
var grabbable : bool = true

var spawn_target : Node3D
var hole_spawn : bool = false

@export var acceleration : float = 250
@export var fly_speed : float = 15

var gameplay_manager: GameplayManager

func _ready() -> void:
	gameplay_manager = get_tree().get_first_node_in_group("GameplayManager")
	value = randi_range(gameplay_manager.current_min_coin_value, gameplay_manager.current_max_coin_value)


func _physics_process(delta: float) -> void:
	if hole_spawn and spawn_target != null :
		physics_material_override.friction = 0
		
		var distance = global_position.distance_to(spawn_target.global_position)
		if distance >= 2 :
			var dir = (spawn_target.global_position - global_position).normalized()
			
			
			linear_velocity = linear_velocity.move_toward(dir * fly_speed, delta * acceleration)
		else :
			hole_spawn = false
			spawn_target = null
			physics_material_override.friction = 1
