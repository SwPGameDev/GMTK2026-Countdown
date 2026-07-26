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

@export var rotation_speed : float = TAU * 2

@export var player : PlayerBehavior

@export var holding : bool = false
@export var is_attacking : bool = false
@export var has_clicked : bool = false

@export var look_at_mouse_length : float = 2
var _look_at_mouse_timer : float = 0

var look_target : Vector3
var last_look_target : Vector3

func _ready() -> void:
	last_look_target = Vector3.FORWARD

func _process(delta: float) -> void:
	holding = player.player_grab.holding_obj
	is_attacking = player.player_combat.attacking
	
	
	if Input.is_action_just_pressed("attack") :
		has_clicked = true
		_look_at_mouse_timer = 0
	
	if has_clicked :
		if _look_at_mouse_timer >= look_at_mouse_length :
			has_clicked = false
		else :
			_look_at_mouse_timer += delta
	
	
	
	
	
	if holding :
		look_mode = LookMode.Holding
	elif is_attacking :
		look_mode = LookMode.Click
	elif has_clicked :
		look_mode = LookMode.Mouse
	elif player.player_movement.direction != Vector3.ZERO :
		look_mode = LookMode.Move
	else :
		look_mode = LookMode.None
	
	
	
	match look_mode :
		LookMode.None :
			pass
		LookMode.Holding :
			# May need to change to project on plane method... currently kinda working
			var blarg : Vector3 = Vector3(player.player_grab.grabbed_obj.global_position.x, player.global_position.y, player.player_grab.grabbed_obj.global_position.z)
			look_target = blarg - player.global_position
			
		LookMode.Click :
			var blarg : Vector3 = Vector3(player.player_combat.click_pos.x, player.global_position.y, player.player_combat.click_pos.z)
			look_target = blarg - player.global_position
			
		LookMode.Mouse :
			var blarg : Vector3 = Vector3(player.player_combat.mouse_pos.x, player.global_position.y, player.player_combat.mouse_pos.z)
			look_target = blarg - player.global_position
			
		LookMode.Move :
			if (player.player_movement.direction != Vector3.ZERO) :
				look_target = player.player_movement.direction
			else :
				look_target = last_look_target
	
	if look_target != Vector3.ZERO :
		var rotate_mod : float = 1
		if look_mode == LookMode.Click :
			rotate_mod = 5
		var rotation_target : Quaternion = Basis.looking_at(look_target, Vector3.UP, true).orthonormalized()
		# Only y axis rotation go here
		var new_rotation : Quaternion = player.mesh.basis.orthonormalized().slerp(rotation_target, delta * rotation_speed * rotate_mod)
		
		player.mesh.basis = new_rotation
	
	
	
	
	
	
	
	
	last_look_target = player.mesh.basis.z
	
	
	if (debug) :
		DebugDraw.draw_line_relative_thick(player.mesh.global_position, player.mesh.global_basis.x, 2, Color.RED)
		DebugDraw.draw_line_relative_thick(player.mesh.global_position, player.mesh.global_basis.y, 2, Color.GREEN)
		DebugDraw.draw_line_relative_thick(player.mesh.global_position, player.mesh.global_basis.z, 2, Color.BLUE)
		
		#DebugDraw.draw_line_relative_pointy(rb.global_position, rb.linear_velocity, 2, Color(1, 1, 0, 0.25))
		DebugDraw.draw_line_relative_pointy(look_target + player.global_position, Vector3.UP, 10, Color.CYAN)
		DebugDraw.draw_line_relative_pointy(player.player_combat.click_pos, Vector3.UP, 10, Color.PURPLE)
		DebugDraw.draw_line_relative_pointy(player.player_combat.mouse_pos, Vector3.UP, 10, Color.YELLOW)
		
