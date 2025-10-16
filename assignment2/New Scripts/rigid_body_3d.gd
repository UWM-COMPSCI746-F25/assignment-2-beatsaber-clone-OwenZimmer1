extends RigidBody3D

@export var cube_color: Color = Color.BLUE
@export var move_speed: float = 3.0
@onready var mesh: MeshInstance3D = $MeshInstance3D

var spawner: Node = null

func _ready():
	var mat = StandardMaterial3D.new()
	mat.albedo_color = cube_color
	mesh.set_surface_override_material(0, mat)

func _physics_process(delta):
	translate(Vector3(0, 0, move_speed * delta))
	if global_position.z > 1.0:  # went past player
		queue_free()

func on_hit_by_saber(saber_color: Color):
	if saber_color.is_equal_approx(cube_color):
		queue_free()
		if spawner:
			spawner.play_hit_sound()
