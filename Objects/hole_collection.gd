extends Node

@export_flags_3d_physics var ground_layer
@export_flags_3d_physics var ground_mask
@export_flags_3d_physics var hole_layer
@export_flags_3d_physics var hole_mask

func _on_collect_trigger_body_entered(body : Node3D) -> void:
	print("COLLECTED: " + body.name)
	TryCollect(body)


func TryCollect(body : Node3D) :
	pass


func _on_hole_zone_body_entered(body: Node3D) -> void:
	if body is RigidBody3D :
		print(str(body.name) + " | ENTERED")
		var rb : RigidBody3D = body
		rb.collision_layer = hole_layer # Think only mask needs to be set, need to understand how layers and masks actually work
		rb.collision_mask = hole_mask

func _on_hole_zone_body_exited(body: Node3D) -> void:
	if body is RigidBody3D :
		print(str(body.name) + " | EXITED")
		var rb : RigidBody3D = body
		rb.collision_layer = ground_layer
		rb.collision_mask = ground_mask
