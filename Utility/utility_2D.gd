extends Node2D

var physics_space : PhysicsDirectSpaceState2D # Needs to be updated when things are moved

func DoRayCast(origin : Vector2, end : Vector2, length : float, can_collide_with_areas : bool, exclude_col : CollisionObject2D) -> Dictionary :
	physics_space = get_world_2d().direct_space_state
	var result : Dictionary
	var query = PhysicsRayQueryParameters2D.create(origin, end * length)
	query.collide_with_areas = can_collide_with_areas
	query.exclude = [exclude_col]
	result = physics_space.intersect_ray(query)
	
	return result

func MouseViewPortRayCast(ray_length : float = 1000, collision_mask : int = 4294967295) -> Dictionary :
	physics_space = get_world_2d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()
	var origin = get_viewport().get_camera_2d().project_ray_origin(mousepos)
	var end = origin + get_viewport().get_camera_2d().project_ray_normal(mousepos) * ray_length
	var query = PhysicsRayQueryParameters2D.create(origin, end, collision_mask)
	query.collide_with_areas = false
	
	var result = physics_space.intersect_ray(query)
	
	return result

func TryCircleCast(pos : Vector2, radius : float, max_results : int, collision_mask : int = 4294967295) -> Array[Dictionary] :
	physics_space = get_world_2d().direct_space_state
	var shape_rid = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(shape_rid, radius)
	
	var params = PhysicsShapeQueryParameters2D.new()
	params.shape_rid = shape_rid
	params.transform.origin = pos
	params.collision_mask = collision_mask
	
	var result = physics_space.intersect_shape(params, max_results)
	
	PhysicsServer2D.free_rid(shape_rid)
	
	return result
