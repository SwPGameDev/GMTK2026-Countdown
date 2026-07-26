extends RigidBody3D
class_name Enemy

@export_group("Debug")
@export var debug_enabled : bool
@export var debug_target : Node3D

@export_group("Refernces")
@export var navigation_agent: NavigationAgent3D
@export var anim : AnimationPlayer

@export_group("Tracking")
@export var target : Node3D = null
@export var current_hp : float
@export var has_spawned_box : bool = false
@export var is_dead : bool = false
@export var in_range : bool
@export var on_cooldown : bool


@export_group("Stats")
@export var movement_speed: float = 4.0
@export var max_hp : float = 4
@export var attack_cooldown : float = 1
var _attack_cooldown_timer : float = 0




func _ready() -> void:
	current_hp = max_hp
	
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	
	if debug_enabled :
		target = debug_target
	else :
		TryGetTarget()
	
	anim.play("run_forward")

func _process(_delta: float) -> void:
	if target != null :
		set_movement_target(target.global_position)
	
	if anim.is_playing() :
		pass
	else :
		anim.play("run_forward")

func _physics_process(_delta):
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		return

	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)


func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _on_velocity_computed(safe_velocity: Vector3):
	linear_velocity = safe_velocity

func TryGetTarget() :
	var player : Node3D = get_tree().get_first_node_in_group("Player")
	if player != null :
		target = player

func TakeHit(damage : float) :
	
	var flip : int = randi_range(0, 1)
	if flip == 0 :
		anim.play("take_hit")
	else :
		anim.play("take_hit_2")
	
	current_hp -= damage
	if current_hp <= 0 :
		Die()

func SpawnBox() :
	has_spawned_box = true
	# blah

func Die() :
	if not is_dead :
		is_dead = true
		print("OOF")
		target = null
		
		# Ragdoll
		axis_lock_angular_x = false
		axis_lock_angular_y = false
		axis_lock_angular_z = false
		
		#var random_angle: float = randf_range(0.0, TAU)
		#Vector2.from_angle(random_angle)
		#var rand_vect : Vector3
		
		apply_central_impulse(Vector3.UP * randf_range(-50, 50))
		
		navigation_agent.process_mode = Node.PROCESS_MODE_DISABLED
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		physics_material_override.friction = 1
		
		if not has_spawned_box :
			SpawnBox()
		




#
