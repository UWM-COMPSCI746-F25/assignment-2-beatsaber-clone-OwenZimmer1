extends XRController3D

@export var raycast_length = 1.5
@export var visibility = true

func _physics_process(delta):
	if not visibility: return
	var space_state = get_world_3d().direct_space_state
	
	var origin = global_position
	var dir = global_basis.z * -1
	var end = origin + (dir * raycast_length)
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	
	$LineRight.points[0] = origin + dir * .1
	$LineRight.points[1] = end
	
	if result:
		$LineRight.points[1] = result.position
		
		if result.collider.name.contains("right"):
			result.collider.queue_free()
			
func _on_button_pressed(name):
	if name == "ax_button":
		if not visibility:
			$LineRight.transparency = 0
			visibility = true
		else:
			visibility = false
			$LineRight.points[0] = Vector3(0, 0, 0)
			$LineRight.points[1] = Vector3(0, 0, 0)
			$LineRight.transparency = 1
			
