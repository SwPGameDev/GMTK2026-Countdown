extends RigidBody3D
class_name Enemy

@export_group("Debug")
@export var debug_enabled : bool
@export var debug_target : Node3D

@export_group("Refernces")
@export var navigation_agent: NavigationAgent3D
@export var mesh : Node3D
@export var hurtbox : Area3D
@export var anim : AnimationPlayer
@export var col : CollisionShape3D
@export var box_scene : PackedScene = preload("res://Objects/valuables_box.tscn")
var gameplay_manager : GameplayManager

@export_group("Tracking")
@export var target : Node3D = null
@export var current_hp : float
@export var has_spawned_box : bool = false
@export var is_dead : bool = false
@export var in_range : bool
@export var on_cooldown : bool

var is_in_hole : bool = false

var look_target : Vector3
var rotation_speed : float = 2 * TAU

@export_group("Stats")
@export var damage : float = 1
@export var movement_speed: float = 4.0
@export var max_hp : float = 4
@export var attack_range : float = 1.75
@export var attack_cooldown : float = 2
var _attack_cooldown_timer : float = 0

var death_delay_length : float = 2
var _death_timer : float = 0

var on_delay_hit_check : bool = false
var delay_hit_length : float = 1
var _delay_timer : float = 0

var attacking : bool = false
var attacking_duration : float = 1.5
var _attacking_timer : float = 0

var staggered : bool = false

func _ready() -> void:
	current_hp = max_hp
	
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	
	gameplay_manager = get_tree().get_first_node_in_group("GameplayManager")
	
	if debug_enabled :
		target = debug_target
	else :
		TryGetTarget()
	
	anim.play("run_forward")

func _process(delta: float) -> void:
	if is_dead :
		_death_timer += delta
		if _death_timer >= death_delay_length :
			queue_free()
		return
	
	if anim.is_playing() :
		pass
	else :
		anim.play("run_forward")
	
	if anim.current_animation == "take_hit" or anim.current_animation == "take_hit_2" :
		staggered = true
	else :
		staggered = false
		
		if anim.current_animation == "swing_1" or anim.current_animation == "swing_2" or anim.current_animation == "swing_3" :
			attacking = true
		else :
			attacking = false
	
	
	
	if on_cooldown :
		_attack_cooldown_timer += delta
		if _attack_cooldown_timer >= attack_cooldown :
			on_cooldown = false
			_attack_cooldown_timer = 0
	
	if on_delay_hit_check :
		_delay_timer += delta
		if _delay_timer >= delay_hit_length :
			on_delay_hit_check = false
			_delay_timer = 0
			TryHit(hurtbox)
	
	#if attacking :
		#_attacking_timer += delta
		#if _attacking_timer >= attacking_duration :
			#attacking = false
			#_attacking_timer = 0
	
	
	
	if target != null :
		set_movement_target(target.global_position)
		
		var distance : float = self.global_position.distance_to(target.global_position)
		if distance < attack_range :
			in_range = true
		else :
			in_range = false
		
		if in_range and not on_cooldown and not attacking and not on_delay_hit_check :
			print("ATTACKING")
			TryAttack()
	
	look_target = target.global_position - global_position
	if look_target != Vector3.ZERO :
		var rotation_target : Quaternion = Basis.looking_at(look_target, Vector3.UP, true).orthonormalized()
		# Only y axis rotation go here
		var new_rotation : Quaternion = mesh.basis.orthonormalized().slerp(rotation_target, delta * rotation_speed)
		
		mesh.basis = new_rotation

func _physics_process(_delta):
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		return

	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	
	var new_velocity: Vector3
	
	var mod_speed : float = movement_speed
	
	if anim.current_animation == "take_hit" or anim.current_animation == "take_hit_2" :
		mod_speed = 0
	if attacking :
		mod_speed = movement_speed / 4
	
	var y_vel = linear_velocity.y
	
	
	new_velocity = global_position.direction_to(next_path_position) * mod_speed
	new_velocity.y = y_vel
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
	
	
	if is_in_hole :
		apply_force(Vector3.DOWN * 100)


func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _on_velocity_computed(safe_velocity: Vector3):
	linear_velocity = safe_velocity

func TryGetTarget() :
	var player : Node3D = get_tree().get_first_node_in_group("Player")
	if player != null :
		target = player




func TryHit(area : Area3D) :
	var hit_bodies : Array[Node3D] = area.get_overlapping_bodies()
	if not hit_bodies.is_empty() :
		for bod in hit_bodies :
			if bod is PlayerBehavior :
				var player : PlayerBehavior = bod
				player.TakeHit(damage)


func TryAttack() :
	
	# if not staggered :
	attacking = true
	
	on_delay_hit_check = true
	
	var flip : int = randi_range(0, 2)
	
	on_cooldown = true
	
	if flip == 0 :
		anim.play("swing_1")
	elif flip == 1 :
		anim.play("swing_2")
	else :
		anim.play("swing_3")



func TakeHit(damage_param : float) :
	var flip : int = randi_range(0, 1)
	
	on_cooldown = true
	_attack_cooldown_timer = 0
	
	on_delay_hit_check = false
	_delay_timer = 0
	
	attacking = false
	_attacking_timer = 0
	
	
	
	current_hp -= damage_param
	if current_hp <= 0 :
		Die()
	else :
		
		if flip == 0 :
			anim.play("take_hit")
		else :
			anim.play("take_hit_2")
	
	

func SpawnBox() :
	has_spawned_box = true
	
	var new_box : ValueableBox = box_scene.instantiate()
	gameplay_manager.level_root.add_child(new_box)
	new_box.global_position = Vector3(global_position.x, global_position.y + 1, global_position.z)

func Die() :
	if not is_dead :
		is_dead = true
		print("OOF")
		anim.play("death")
		target = null
		
		freeze = true
		col.set_deferred("disabled", true)
		
		
		if not has_spawned_box :
			SpawnBox()






#
