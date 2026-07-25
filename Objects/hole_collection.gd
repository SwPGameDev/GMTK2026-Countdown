extends Node

@export_flags_3d_physics var default_layer
@export_flags_3d_physics var default_mask
@export_flags_3d_physics var interactable_layer
@export_flags_3d_physics var hole_layer
@export_flags_3d_physics var hole_mask

@onready var gameplay_manager : GameplayManager = %GamePlayManger

# Bottom Trigger
func _on_collect_trigger_body_entered(body : Node3D) -> void:
	TryCollect(body)


func TryCollect(body : Node3D) :
	print("COLLECTED: " + body.name)
	
	if body is ValueableBox :
		var vb : ValueableBox = body
		gameplay_manager.CollectGold(vb.value)
		vb.queue_free()
	elif body is Enemy :
		var enemy : Enemy = body
		if not enemy.has_spawned_box :
			enemy.SpawnBox()
		enemy.queue_free()
	elif body is PlayerBehavior :
		var player : PlayerBehavior = body
		player.Die()
		

# Top Trigger
func _on_hole_zone_body_entered(body: Node3D) -> void:
	if body is RigidBody3D :
		print(str(body.name) + " | ENTERED")
		var rb : RigidBody3D = body
		rb.collision_layer = hole_layer
		rb.collision_mask = hole_mask

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
		enemy.Die()





#
