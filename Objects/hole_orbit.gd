extends Node

@export var hole : AnimatableBody3D

@export var follow_mode : bool = false
@export var target : Node3D

@export var follow_speed : float = 1
@export var rotate_speed : float = 1
@export var offset : Vector3 = Vector3(0, 0, 0)
@export var amplitude : Vector3 = Vector3(5, 0, 5)

var goal_pos : Vector3
var time : float = 0

func _physics_process(delta: float) -> void:
	time += delta
	
	var x_pos = cos(time * rotate_speed + offset.x) * amplitude.x
	var z_pos = sin(time * rotate_speed + offset.z) * amplitude.z
	
	
	if follow_mode :
		goal_pos = target.global_position
		hole.global_position = hole.global_position.move_toward(goal_pos, follow_speed * delta)
	else :
		goal_pos = Vector3(x_pos, 0, z_pos)
		hole.global_position = goal_pos
