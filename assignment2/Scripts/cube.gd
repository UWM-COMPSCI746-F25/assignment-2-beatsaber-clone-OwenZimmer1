extends Node3D

@export var speed: float = 6.0        # tune to taste
@export var color_name: String = "right"  # or "left"
@export var destroy_sound: AudioStream   # assign in inspector

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready():
	# set the material color based on color_name
	var mat = StandardMaterial3D.new()
	if color_name == "right":
		mat.albedo_color = Color(0.0, 0.4, 1.0) # blue-ish
	else:
		mat.albedo_color = Color(1.0, 0.2, 0.2) # red-ish
	mesh.material_override = mat

	# set up audio
	if destroy_sound:
		audio.stream = destroy_sound

func _process(delta):
	# move forward in local -Z (spawn facing player so -Z moves toward player)
	translate(Vector3(0, 0, speed * delta)) # careful: we will spawn such that +Z is toward player
	# NOTE: spawn orientation and sign must match spawner; adjust sign if wrong

	# destroy if it goes "past" the player (e.g., z > some threshold)
	var global_z = global_transform.origin.z
	# assume player is at z == 0; if passing -> > 1.0 treat as missed
	if global_z > 2.0:
		queue_free()  # no sound for missed cubes

func try_hit(sword_color_name: String) -> void:
	# called from the sword when overlapping
	if sword_color_name == color_name:
		destroy_by_sword()
	else:
		# wrong color => ignore
		pass

func destroy_by_sword() -> void:
	if audio.stream:
		audio.play()
	# optionally spawn particles / small debris here (bonus)
	queue_free()
