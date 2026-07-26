extends RigidBody3D
class_name PlayerBehavior

@export_group("References")
var gameplay_manager : GameplayManager
@export var anim_tree : AnimationTree
# move blend : 0 idle_loop -- 1 run_loop
# parameters/move_blend/blend_amount

#parameters/swing_one_shot/request

# move_mode_blend : -1 push -- 0 move -- 1 falling
#parameters/move_mode_blend/blend_amount

# parameters/push_blend/blend_amount

# parameters/take_hit_oneshot/request

### Examples
# animation_tree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
# animation_tree["parameters/eye_blend/blend_amount"] = 1.0


@export var mesh : Node3D
@export var cam : Camera3D
@export var player_movement : PlayerMovement
@export var player_combat : PlayerCombat
@export var player_look : PlayerLook
@export var player_grab : PlayerGrab

@export_group("Stats")
# Combat
@export var max_hp : float = 12
var current_hp : float
@export var damage : float = 2
@export var attack_cooldown : float = 0.5
@export var swing_speed : float = 2.2 # Could make this value swing anim length / attack_cooldown or something
# Movement
@export var move_speed : float = 10
@export var acceleration : float = 250
@export var deceleration : float = 250
# Grab
@export var move_force : float = 500
@export var hold_force : float = 1000

var is_dead : bool = false

func _ready() -> void :
	gameplay_manager = get_tree().get_first_node_in_group("GameplayManager")
	
	current_hp = max_hp
	
	if cam == null :
		cam = get_viewport().get_camera_3d()
	
	anim_tree["parameters/move_blend/blend_amount"] = 0


func _process(delta: float) -> void :
	var move_blend_val : float = clamp((self.linear_velocity / move_speed).length(), 0, 1)
	
	if player_grab.holding_obj :
		anim_tree["parameters/move_mode_blend/blend_amount"] = -1
		anim_tree["parameters/push_blend/blend_amount"] = move_blend_val
	else :
		anim_tree["parameters/move_mode_blend/blend_amount"] = 0
		anim_tree["parameters/move_blend/blend_amount"] = move_blend_val
		
	


func ReleaseGrab() :
	player_grab.TryReleaseHold()

func ResetToPlayerSpawn() :
	is_dead = false
	ReleaseGrab()
	current_hp = max_hp
	gameplay_manager.UpdatePlayerHPLabel(current_hp, max_hp)
	
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	basis = Basis.IDENTITY
	
	global_position = gameplay_manager.player_spawn_point.global_position
	self.reset_physics_interpolation()
	
	cam.HardUpdatePos()
	
	player_movement.process_mode = Node.PROCESS_MODE_INHERIT
	player_combat.process_mode = Node.PROCESS_MODE_INHERIT
	player_look.process_mode = Node.PROCESS_MODE_INHERIT
	player_grab.process_mode = Node.PROCESS_MODE_INHERIT

func TakeHit(damage_param : float) :
	if not is_dead :
		current_hp -= damage_param
		gameplay_manager.UpdatePlayerHPLabel(current_hp, max_hp)
		if current_hp <= 0 :
			Die()
			current_hp = 0
			gameplay_manager.UpdatePlayerHPLabel(current_hp, max_hp)
			return
		
		#var flip : int = randi_range(0, 1)
		#if flip == 0 :
			#anim.play("take_hit")
		#else :
			#anim.play("take_hit_2")
		
		anim_tree["parameters/take_hit_oneshot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE


func Swing() :
	var flip : int = randi_range(0, 1)
	
	anim_tree["parameters/swing_choose/blend_amount"] = flip
	
	
	anim_tree["parameters/swing_one_shot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	


func Die() :
	is_dead = true
	# anim.play("death")
	anim_tree["parameters/death_one_shot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	
	
	ReleaseGrab()
	player_movement.process_mode = Node.PROCESS_MODE_DISABLED
	player_combat.process_mode = Node.PROCESS_MODE_DISABLED
	player_look.process_mode = Node.PROCESS_MODE_DISABLED
	player_grab.process_mode = Node.PROCESS_MODE_DISABLED
	
	gameplay_manager.DelayedEndRound(2)





#
