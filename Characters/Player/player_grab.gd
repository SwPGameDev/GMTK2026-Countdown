extends Node

@export var holding_obj : bool
@export var grabbed_obj : RigidBody3D

@export var player : RigidBody3D
@export var interact_sphere : Area3D
var nearest_rb : RigidBody3D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") :
		if holding_obj :
			holding_obj = false
			grabbed_obj = null
			nearest_rb = null
		else :
			nearest_rb = FindNearestRB()
			
			if nearest_rb != null :
				holding_obj = true
				grabbed_obj = nearest_rb


func FindNearestRB() -> RigidBody3D :
	var nearby_bods : Array[Node3D] = interact_sphere.get_overlapping_bodies()
	var nearby_rbs : Array[RigidBody3D] = []
	
	var closest_rb : RigidBody3D = null
	var smallest_distance : float = INF
	
	if not nearby_bods.is_empty() :
		for bod in nearby_bods :
			if bod is RigidBody3D :
				nearby_rbs.append(bod)
	
	if not nearby_rbs.is_empty() :
		for rb : RigidBody3D in nearby_rbs :
			var distance = player.global_position.distance_to(rb.global_position)
			
			if distance < smallest_distance :
				smallest_distance = distance
				closest_rb = rb
	
	
	return closest_rb






















#
