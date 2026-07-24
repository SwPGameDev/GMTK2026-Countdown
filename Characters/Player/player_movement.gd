extends Node

@export_group("Debug Visuals")
@export var debug_enable : bool

@export_group("Refernces")
@export var rb : RigidBody3D

@export_group("Stats")
@export var move_speed : float = 20
@export var acceleration : float = 5
@export var deceleration : float = 5

var horizontal_input : float
var vertical_input : float
var input_vector : Vector3

func _process(_delta: float) -> void:
	#horizontal_input = Input.get_axis("move_left", "move_right")
	#vertical_input = Input.get_axis("move_up", "move_down")
	
	input_vector = Vector3(horizontal_input, 0, vertical_input).normalized()

func _physics_process(delta: float) -> void:
	#if input_vector != Vector3.ZERO:
		#rb.linear_velocity = rb.linear_velocity.move_toward(input_vector * move_speed, acceleration * delta)
	#else:
		#rb.linear_velocity = rb.linear_velocity.move_toward(Vector3.ZERO, deceleration * delta)
	
	
	var input_dir := Input.get_vector("move_right", "move_left", "move_back", "move_forward")
	var direction := (rb.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		rb.linear_velocity.x = direction.x * move_speed
		rb.linear_velocity.z = direction.z * move_speed
	else:
		rb.linear_velocity.x = move_toward(rb.linear_velocity.x, 0, move_speed)
		rb.linear_velocity.z = move_toward(rb.linear_velocity.z, 0, move_speed)
	
	
	
