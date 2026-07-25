extends Node
class_name PlayerLook

# Look Priority:
## Holing onto obj
## Player attacked
## Mouse pos while timer active
## Move direction
## Last look target

@export var debug : bool

enum LookMode {None, Holding, Click, Mouse, Move}
@export var look_mode : LookMode

@export var rotationSpeed : float = TAU * 2

@export var player_grab : Node # Get held obj
@export var player_movement : Node # Get move dir
@export var player_combat : Node # Get click event and click pos

@export var rb : RigidBody3D
@export var mesh: MeshInstance3D

@export var holding : bool = false
@export var is_attacking : bool = false
@export var has_clicked : bool = false

var look_target : Vector3
var last_look_target : Vector3

func _ready() -> void:
	last_look_target = Vector3.FORWARD

func _process(delta: float) -> void:
	holding = player_grab.holding_obj
	#is_attacking = player_combat.attacking
	
	if holding :
		look_mode = LookMode.Holding
	elif is_attacking :
		pass
	elif has_clicked :
		look_mode = LookMode.Click
	elif player_movement.direction != Vector3.ZERO :
		look_mode = LookMode.Move
	else :
		look_mode = LookMode.None
	
	
	
	match look_mode :
		LookMode.None :
			pass
		LookMode.Holding :
			# Need to change to project on plane method
			var blarg : Vector3 = Vector3(player_grab.grabbed_obj.global_position.x, rb.global_position.y, player_grab.grabbed_obj.global_position.z)
			look_target = blarg - rb.global_position
		LookMode.Click :
			# Need to change to project on plane method
			var blarg : Vector3 = Vector3(player_combat.click_pos.x, rb.global_position.y, player_combat.click_pos.z)
			look_target = blarg - rb.global_position
		LookMode.Mouse :
			
			
			
			pass
		LookMode.Move :
			if (player_movement.direction != Vector3.ZERO) :
				look_target = player_movement.direction
			else :
				look_target = last_look_target
	
	if look_target != Vector3.ZERO :
		var rotation_target : Quaternion = Basis.looking_at(look_target, Vector3.UP, true).orthonormalized()
		# Only y axis rotation go here
		var new_rotation : Quaternion = mesh.basis.orthonormalized().slerp(rotation_target, delta * rotationSpeed)
		
		mesh.basis = new_rotation
	
	last_look_target = mesh.basis.z
	
	
	if (debug) :
		DebugDraw.draw_line_relative_thick(mesh.global_position, mesh.global_basis.x, 2, Color.RED)
		DebugDraw.draw_line_relative_thick(mesh.global_position, mesh.global_basis.y, 2, Color.GREEN)
		DebugDraw.draw_line_relative_thick(mesh.global_position, mesh.global_basis.z, 2, Color.BLUE)
		
		#DebugDraw.draw_line_relative_pointy(rb.global_position, rb.linear_velocity, 2, Color(1, 1, 0, 0.25))
		DebugDraw.draw_line_relative_pointy(look_target + rb.global_position, Vector3.UP, 10, Color.CYAN)
		DebugDraw.draw_line_relative_pointy(player_combat.click_pos, Vector3.UP, 10, Color.PURPLE)
		
