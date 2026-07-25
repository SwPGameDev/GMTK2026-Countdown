extends Node
class_name PlayerMovement

@export_group("Debug")
@export var debug_visuals : bool
@export var debug_print : bool

@export_group("Refernces")
@export var level_root : Node3D
@export var cam : Camera3D
@export var player : PlayerBehavior
@export var mesh : MeshInstance3D
@export var player_grab : PlayerGrab
var holding_target_offset : Vector3
var holding_target_pos : Vector3

@export_group("Move Mode")
enum MoveMode{None, Player, Grabbed}
@export var move_mode : MoveMode


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
	
	direction = (player.transform.basis * relative_input).normalized()
	#direction.y = 0
	
	if debug_visuals :
		if player_grab.grabbed_obj != null :
			DebugDraw.draw_line_relative_thick(player_grab.grabbed_obj.global_position + holding_target_offset, Vector3.UP * 5, 2)
	
	if player_grab.holding_obj :
		if move_mode != MoveMode.Grabbed :
			move_mode = MoveMode.Grabbed
			holding_target_offset = player.global_position - player_grab.grabbed_obj.global_position
			 
	else :
		if move_mode != MoveMode.Player :
			move_mode = MoveMode.Player
			holding_target_offset = Vector3.ZERO
	
	if holding_target_offset != Vector3.ZERO :
		holding_target_pos = player_grab.grabbed_obj.global_position + holding_target_offset

func _physics_process(delta: float) -> void:
	if move_mode == MoveMode.Player :
		if direction :
			player.linear_velocity.x  = move_toward(player.linear_velocity.x , direction.x * player.move_speed, player.acceleration * delta)
			player.linear_velocity.z = move_toward(player.linear_velocity.z, direction.z * player.move_speed, player.acceleration * delta)
		else :
			player.linear_velocity.x = move_toward(player.linear_velocity.x, 0.0, player.deceleration * delta)
			player.linear_velocity.z = move_toward(player.linear_velocity.z, 0.0, player.deceleration * delta)
	elif move_mode == MoveMode.Grabbed :
		
		var correction_dir : Vector3 = holding_target_pos - player.global_position
		if debug_visuals :
			DebugDraw.draw_line_relative_pointy(player.global_position, correction_dir, 10, Color.WHITE)
		player.linear_velocity.x  = move_toward(player.linear_velocity.x , correction_dir.x * player.move_speed * 10, player.acceleration * 10 * delta)
		player.linear_velocity.z = move_toward(player.linear_velocity.z, correction_dir.z * player.move_speed * 10, player.acceleration * 10 * delta)
		
		if player_grab.grabbed_obj != null :
			if direction :
				player_grab.grabbed_obj.apply_central_force(direction * player.move_force)
				player_grab.grabbed_obj.linear_velocity = player_grab.grabbed_obj.linear_velocity.clamp(-player.move_speed * Vector3.ONE, player.move_speed * Vector3.ONE)
			else :
				player_grab.grabbed_obj.linear_velocity.move_toward(Vector3.ZERO, player.hold_force * delta)
	
	if debug_visuals :
		DebugDraw.draw_line_relative_pointy(player.global_position, direction, 2, Color.MAGENTA)
	if debug_print :
		print(player.linear_velocity)
		print("SPEED: " + str(player.linear_velocity.length()))
	









#
