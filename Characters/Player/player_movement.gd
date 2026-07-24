extends Node

@export_group("Debug")
@export var debug_visuals : bool
@export var debug_print : bool

@export_group("Refernces")
@export var cam : Camera3D
@export var rb : RigidBody3D
@export var mesh : MeshInstance3D

@export_group("Stats")
@export var move_speed : float = 20
@export var acceleration : float = 5
@export var deceleration : float = 5

var input_dir : Vector2

var forward_relative : Vector3
var right_relative : Vector3
var relative_input : Vector3
var direction : Vector3

func _process(_delta: float) -> void:
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	forward_relative = input_dir.y * cam.global_basis.z
	forward_relative = Vector3(forward_relative.x, 0, forward_relative.z).normalized()
	right_relative = input_dir.x * cam.global_basis.x
	relative_input = (forward_relative + right_relative).normalized()
	relative_input.y = 0
	
	direction = (rb.transform.basis * relative_input).normalized()
	#direction.y = 0

func _physics_process(delta: float) -> void:
	if direction:
		rb.linear_velocity.x  = move_toward(rb.linear_velocity.x , direction.x * move_speed, acceleration * delta)
		rb.linear_velocity.z = move_toward(rb.linear_velocity.z, direction.z * move_speed, acceleration * delta)
	else:
		rb.linear_velocity.x = move_toward(rb.linear_velocity.x, 0.0, deceleration * delta)
		rb.linear_velocity.z = move_toward(rb.linear_velocity.z, 0.0, deceleration * delta)
	
	
	if debug_visuals :
		DebugDraw.draw_line_relative_pointy(rb.global_position, direction, 2, Color.MAGENTA)
	if debug_print :
		print(rb.linear_velocity)
		print("SPEED: " + str(rb.linear_velocity.length()))
	
