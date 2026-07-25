extends RigidBody3D
class_name PlayerBehavior

@export_group("References")
@onready var gameplay_manager : GameplayManager = %GamePlayManger
@export var cam : Camera3D
@export var player_movement : PlayerMovement
@export var player_combat : PlayerCombat
@export var player_look : PlayerLook
@export var player_grab : PlayerGrab

@export_group("Stats")
@export var max_hp : float = 12
var current_hp : float
@export var damage : float = 2
@export var attack_cooldown : float = 0.5


@export var move_speed : float = 10
@export var acceleration : float = 250
@export var deceleration : float = 250
@export var move_force : float = 500
@export var hold_force : float = 1000


func ReleaseGrab() :
	player_grab.TryReleaseHold()

func ResetToPlayerSpawn() :
	print("Hello?")
	ReleaseGrab()
	axis_lock_angular_x = true
	axis_lock_angular_y = true
	axis_lock_angular_z = true
	
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

func Die() :
	# Ragdoll
	axis_lock_angular_x = false
	axis_lock_angular_y = false
	axis_lock_angular_z = false
	
	ReleaseGrab()
	player_movement.process_mode = Node.PROCESS_MODE_DISABLED
	player_combat.process_mode = Node.PROCESS_MODE_DISABLED
	player_look.process_mode = Node.PROCESS_MODE_DISABLED
	player_grab.process_mode = Node.PROCESS_MODE_DISABLED
	
	gameplay_manager.DelayedEndRound(1)





#
