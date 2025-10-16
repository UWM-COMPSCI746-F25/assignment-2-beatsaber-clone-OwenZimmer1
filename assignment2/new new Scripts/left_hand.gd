extends XRController3D

@export var raycast_length = 1.5
@export var visibility = true

func _physics_process(delta):
	print("hi")
	if not visibility: return
	var space_state = get_world_3d().direct_space_state
	
	var origin = global_position
	var dir = global_basis.z * -1
	var end = origin + (dir * raycast_length)
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	
	$LineLeft.points[0] = origin + dir * .1
	$LineLeft.points[1] = end
	
	if result:
		$LineLeft.points[1] = result.position
		
		if result.collider.name.contains("left"):
			result.collider.queue_free()
			
func _on_button_pressed(name):
	if name == "ax_button":
		if $LineLeft.transparency == 1:
			$LineLeft.transparency = 0
			visibility = true
		else:
			visibility = false
			$LineLeft.points[0] = Vector3(0, 0, 0)
			$LineLeft.points[1] = Vector3(0, 0, 0)
			$LineLeft.transparency = 1
