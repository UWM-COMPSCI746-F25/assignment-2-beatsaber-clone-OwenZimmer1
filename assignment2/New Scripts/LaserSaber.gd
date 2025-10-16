extends RayCast3D

@export var saber_color: Color = Color.BLUE
@export var is_left_saber: bool = false
@export var laser_length: float = 1.0
@export var laser_mesh: MeshInstance3D

var active := true

func _ready():
	# Point along -Z
	target_position = Vector3(0, 0, -laser_length)
	set_physics_process(true)
	_update_laser_color()

func _physics_process(_delta):
	if not active:
		return

	if is_colliding():
		var hit = get_collider()
		if hit and hit.has_method("on_hit_by_saber"):
			hit.on_hit_by_saber(saber_color)

func _update_laser_color():
	if laser_mesh:
		var mat = StandardMaterial3D.new()
		mat.emission_enabled = true
		mat.emission = saber_color
		laser_mesh.set_surface_override_material(0, mat)

func toggle_laser():
	active = !active
	visible = active
	if laser_mesh:
		laser_mesh.visible = active
