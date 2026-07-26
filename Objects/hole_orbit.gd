extends Node

@export var hole : AnimatableBody3D

enum MoveMode{None, Orbit, Follow}
@export var move_mode : MoveMode

@export var target : Node3D

@export var follow_speed : float = 1
@export var orbit_speed : float = 10
@export var rotate_speed : float = 1
@export var offset : Vector3 = Vector3(0, 0, 0)
@export var amplitude : Vector3 = Vector3(5, 0, 5)

var stored_follow_speed : float

var goal_pos : Vector3
var time : float = 0

func _ready() -> void :
	stored_follow_speed = follow_speed
	

func _physics_process(delta: float) -> void :
	if move_mode == MoveMode.Orbit :
		time += delta
	
	var x_pos = cos(time * rotate_speed + offset.x) * amplitude.x
	var z_pos = sin(time * rotate_speed + offset.z) * amplitude.z
	
	
	if move_mode == MoveMode.Follow :
		goal_pos = Vector3(target.global_position.x, hole.global_position.y, target.global_position.z)
		hole.global_position = hole.global_position.move_toward(goal_pos, follow_speed * delta)
	elif move_mode == MoveMode.Orbit :
		goal_pos = Vector3(x_pos, hole.global_position.y, z_pos)
		#hole.global_position = goal_pos
		hole.global_position = hole.global_position.move_toward(goal_pos, orbit_speed * delta)

func SwitchToOrbit() :
	follow_speed = stored_follow_speed
	move_mode = MoveMode.Orbit

func SwitchToFollow() :
	stored_follow_speed = follow_speed
	move_mode = MoveMode.Follow















#
