extends XRController3D

@export var raycast_length = 10

func _physics_process(delta):
	var space_state = get_world_3d().direct_space_state
	var cam = $Camera3D
	
	var origin = global_position
	var dir = global_basis.z * -1
	var end = origin + (dir * raycast_length)
	
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	
	if result:
		print("Collision with ", result.collider.name)
