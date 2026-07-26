extends Node
class_name PlayerGrab

@export var holding_obj : bool
@export var grabbed_obj : RigidBody3D
@export var player : PlayerBehavior
@export var interact_sphere : Area3D
var nearest_rb : RigidBody3D

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") :
		print("E")
		
		CheckForLever()
		
		
		
		if holding_obj :
			TryReleaseHold()
		else :
			TryGrab()

func CheckForLever() :
	var nearby_areas : Array[Area3D] = interact_sphere.get_overlapping_areas()
	if not nearby_areas.is_empty() :
		for area in nearby_areas :
			if area.get_parent() is StartLever :
				var lever : StartLever = area.get_parent()
				lever.FlipLever()
	


func FindNearestRB() -> RigidBody3D :
	var nearby_bods : Array[Node3D] = interact_sphere.get_overlapping_bodies()
	
	var closest_rb : RigidBody3D = null
	var smallest_distance : float = INF
	
	if not nearby_bods.is_empty() :
		for bod in nearby_bods :
			if bod is RigidBody3D :
				var rb : RigidBody3D = bod
				if rb is PlayerBehavior :
					continue
				if rb is ValueableBox :
					var vb : ValueableBox = rb
					if not vb.grabbable :
						continue
				var distance = player.global_position.distance_to(rb.global_position)
				
				if distance < smallest_distance :
					smallest_distance = distance
					closest_rb = rb
	
	return closest_rb

# Grab coin somewhere
func PickupCoin(coin : Node3D) : # Coin)
	# coin.value
	player.gameplay_manager.CollectTempGold(1)
	pass

func TryGrab() :
	nearest_rb = FindNearestRB()
	print("GRABBING: " + str(nearest_rb))
	
	if nearest_rb != null :
		holding_obj = true
		grabbed_obj = nearest_rb

func TryReleaseHold() :
	holding_obj = false
	grabbed_obj = null
	nearest_rb = null



















#
