extends Node

var mouse_pos : Vector2
var click_pos : Vector2

@export var cam : Camera2D

@export var cursor_sprite : Sprite2D
@export var white_texture : CompressedTexture2D
@export var gray_texture : CompressedTexture2D

@export var hurtbox : Area2D
var hit_force : float = 2500

@export var player_sprite : Sprite2D
@export var rotation_speed : float = TAU * 2
@export var rotation_offset : float = 90 ## Degrees

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _process(delta: float) -> void:
	mouse_pos = cam.get_global_mouse_position()
	
	var mouse_dir : Vector2 = (mouse_pos - player_sprite.global_position).normalized()
	player_sprite.rotation = rotate_toward(
		player_sprite.rotation,
		mouse_dir.angle() + deg_to_rad(rotation_offset),
		rotation_speed * delta)
	
	cursor_sprite.global_position = mouse_pos
	
	if Input.is_action_just_pressed("attack") :
		click_pos = get_viewport().get_mouse_position()
		cursor_sprite.texture = gray_texture
		TryHit(hurtbox)
		
		
		
	if Input.is_action_just_released("attack") :
		cursor_sprite.texture = white_texture
	
	
	
	if Input.is_action_just_pressed("pause") :
		if Input.mouse_mode == Input.MOUSE_MODE_CONFINED_HIDDEN :
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE :
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func TryHit(area : Area2D) :
	var hit_bodies : Array[Node2D] = area.get_overlapping_bodies()
	if not hit_bodies.is_empty() :
		for bod in hit_bodies :
			print(bod.name)
			if bod is RigidBody2D :
				print("Rigid")
				var dir : Vector2 = (bod.global_position - player_sprite.global_position).normalized()
				bod.apply_impulse(dir * hit_force)
				if bod is Enemy :
					pass
