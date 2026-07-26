extends Node

@export var coin_scene : PackedScene
@export var box_scene : PackedScene

@export var spawn_pos : Node3D
@export var spawn_target : Node3D

@export_flags_3d_physics var default_layer
@export_flags_3d_physics var default_mask
@export_flags_3d_physics var interactable_layer
@export_flags_3d_physics var hole_layer
@export_flags_3d_physics var hole_mask

var gameplay_manager : GameplayManager

func _ready() -> void:
	gameplay_manager = get_tree().get_first_node_in_group("GameplayManager")


# Bottom Trigger
func _on_collect_trigger_body_entered(body : Node3D) -> void:
	TryCollect(body)


func TryCollect(body : Node3D) :
	print("COLLECTED: " + body.name)
	
	if body is ValueableBox :
		var vb : ValueableBox = body
		SpitOutCoin(vb.value)
		vb.queue_free()
	elif body is Enemy :
		var enemy : Enemy = body
		enemy.Die()
		if not enemy.has_spawned_box :
			SpitOutBox()
		enemy.queue_free()
	elif body is PlayerBehavior :
		var player : PlayerBehavior = body
		player.Die()
		

func SpitOutBox() :
	var new_box : ValueableBox = box_scene.instantiate()
	gameplay_manager.level_root.add_child(new_box)
	new_box.global_position = spawn_pos.global_position
	
	new_box.hole_spawn = true
	new_box.spawn_target = spawn_target

func SpitOutCoin(coin_amount : int) :
	
	for i : int in coin_amount :
		var new_coin : Coin = coin_scene.instantiate()
		gameplay_manager.level_root.add_child(new_coin)
		new_coin.global_position = spawn_pos.global_position
		
		new_coin.hole_spawn = true
		new_coin.spawn_target = spawn_target

# Top Trigger
func _on_hole_zone_body_entered(body: Node3D) -> void:
	if body is RigidBody3D :
		print(str(body.name) + " | ENTERED")
		var rb : RigidBody3D = body
		rb.collision_layer = hole_layer
		rb.collision_mask = hole_mask
		
		if rb is Enemy :
			var enemy : Enemy = rb
			enemy.is_in_hole = true

func _on_hole_zone_body_exited(body: Node3D) -> void:
	if body is ValueableBox :
		print(str(body.name) + " | EXITED")
		var vb : ValueableBox = body
		vb.collision_layer = interactable_layer
		vb.collision_mask = default_mask
	elif body is RigidBody3D :
		print(str(body.name) + " | EXITED")
		var rb : RigidBody3D = body
		rb.collision_layer = default_layer
		rb.collision_mask = default_mask
		
		if rb is Enemy :
			var enemy : Enemy = rb
			enemy.is_in_hole = false

# Middle Trigger
func _on_enter_trigger_body_entered(body: Node3D) -> void:
	print("Detected: " + str(body))
	var player : PlayerBehavior = get_tree().get_first_node_in_group("Player")
	player.ReleaseGrab()
	
	if body is ValueableBox :
		var vb : ValueableBox = body
		vb.grabbable = false
	if body is Enemy :
		var enemy : Enemy = body
		enemy.movement_speed = 0





#
