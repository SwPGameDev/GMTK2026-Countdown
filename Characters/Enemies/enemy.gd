extends RigidBody3D
class_name Enemy

@export var debug_enabled : bool
@export var debug_target : Node3D

var target : Node3D = null
@export var movement_speed: float = 4.0
@export var navigation_agent: NavigationAgent3D

func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	
	if debug_enabled :
		target = debug_target

func _process(_delta: float) -> void:
	if target != null :
		set_movement_target(target.global_position)

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
