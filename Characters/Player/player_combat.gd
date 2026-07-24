extends Node

@export var white_texture : Texture2D
@export var gray_texture : Texture2D

@export var cam : Camera3D
@export var rb : RigidBody3D
@export var hurtbox : Area3D
@export var hit_force : float = 500

var mouse_pos : Vector2
var click_pos : Vector3

@export var rotation_speed : float = TAU * 2
@export var rotation_offset : float = 90 ## Degrees

func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	pass

func _process(delta: float) -> void:
	#mouse_pos = cam.get_global_mouse_position()
	
	#var mouse_dir : Vector2 = (mouse_pos - player_sprite.global_position).normalized()
	
	
	
	if Input.is_action_just_pressed("attack") :
		Input.set_custom_mouse_cursor(gray_texture, Input.CURSOR_ARROW, Vector2(32, 32))
		
		var click_results : Dictionary = Utility.MouseViewPortRayCast()
		
		if not click_results.is_empty() :
			click_pos = click_results.position
			TryHit(hurtbox)
	
	if Input.is_action_just_released("attack") :
		Input.set_custom_mouse_cursor(white_texture, Input.CURSOR_ARROW, Vector2(32, 32))
	
	
	
	if Input.is_action_just_pressed("pause") :
		if Input.mouse_mode == Input.MOUSE_MODE_CONFINED_HIDDEN :
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE :
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func TryHit(area : Area3D) :
	var hit_bodies : Array[Node3D] = area.get_overlapping_bodies()
	if not hit_bodies.is_empty() :
		for bod in hit_bodies :
			print(bod.name)
			if bod is RigidBody3D :
				print("Rigid")
				var dir : Vector3 = (bod.global_position - rb.global_position).normalized()
				bod.apply_impulse(dir * hit_force)
				if bod is Enemy :
					pass
