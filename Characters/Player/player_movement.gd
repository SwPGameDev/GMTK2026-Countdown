extends Node

@export var rb : RigidBody2D

@export var move_speed : float = 50
@export var acceleration : float = 5
@export var deceleration : float = 5

var horizontal_input : float
var vertical_input : float
var input_vector : Vector2

func _process(_delta: float) -> void:
	horizontal_input = Input.get_axis("move_left", "move_right")
	vertical_input = Input.get_axis("move_up", "move_down")
	
	input_vector = Vector2(horizontal_input, vertical_input).normalized()

func _physics_process(delta: float) -> void:
	if input_vector != Vector2.ZERO:
		rb.linear_velocity = rb.linear_velocity.move_toward(input_vector * move_speed, acceleration * delta)
	else:
		rb.linear_velocity = rb.linear_velocity.move_toward(Vector2.ZERO, deceleration * delta)
	
