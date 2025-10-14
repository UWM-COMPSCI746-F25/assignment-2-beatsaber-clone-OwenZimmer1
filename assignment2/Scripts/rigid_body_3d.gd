extends RigidBody3D

@export var speed: float = 4.0
@export var cube_color: Color = Color.BLUE
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var audio_destroy: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready():
	if mesh.material_override:
		mesh.material_override.albedo_color = cube_color

func _physics_process(_delta):
	global_position.z += speed * _delta
	if global_position.z > 1.0:  # Passed player
		queue_free()

func on_hit_by_sword(sword_color: Color):
	if sword_color == cube_color:
		audio_destroy.play()
		await get_tree().create_timer(0.15).timeout
		queue_free()
