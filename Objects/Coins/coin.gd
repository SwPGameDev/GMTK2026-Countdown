extends RigidBody3D
class_name Coin

@export var value : int

var spawn_target : Node3D
var hole_spawn : bool = false

@export var acceleration : float = 250
@export var fly_speed : float = 15


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
