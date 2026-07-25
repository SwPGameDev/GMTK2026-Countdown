extends Node
class_name PlayerCombat

# If grabbing:
## Left click push? Right click drop?
# else :
## left click try swing

@export var player : PlayerBehavior

@export var white_texture : Texture2D
@export var gray_texture : Texture2D

@export var hurtbox : Area3D
@export var hit_force : float = 500


var can_attack : bool = true
var attacking : bool = false


var mouse_pos : Vector3
var click_pos : Vector3

@export var rotation_speed : float = TAU * 2
@export var rotation_offset : float = 90 ## Degrees

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	pass

func _process(delta: float) -> void:
	var mouse_results : Dictionary = Utility.MouseViewPortRayCast()
	if not mouse_results.is_empty() :
		mouse_pos = mouse_results.position
	
	if Input.is_action_just_pressed("attack") :
		Input.set_custom_mouse_cursor(gray_texture, Input.CURSOR_ARROW, Vector2(32, 32))
		
		var click_results : Dictionary = Utility.MouseViewPortRayCast()
		
		if not click_results.is_empty() :
			click_pos = click_results.position
			TryHit(hurtbox)
	
	if Input.is_action_just_released("attack") :
		Input.set_custom_mouse_cursor(white_texture, Input.CURSOR_ARROW, Vector2(32, 32))
	
	
	
	if Input.is_action_just_pressed("pause") :
		if Input.mouse_mode == Input.MOUSE_MODE_CONFINED :
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE :
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func TryHit(area : Area3D) :
	var hit_bodies : Array[Node3D] = area.get_overlapping_bodies()
	if not hit_bodies.is_empty() :
		for bod in hit_bodies :
			print(bod.name)
			if bod is RigidBody3D :
				var dir : Vector3 = (bod.global_position - player.global_position).normalized()
				bod.apply_impulse(dir * hit_force)
				
				if bod is Enemy :
					bod.TakeHit(player.damage)
