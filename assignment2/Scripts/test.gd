extends Node3D

@export var cube_scene: PackedScene
@export var min_interval: float = 0.5
@export var max_interval: float = 2.0
@export var spawn_z: float = -12.0
@export var spawn_x_range: Vector2 = Vector2(-1.2, 1.2)
@export var spawn_y_range: Vector2 = Vector2(-1.0, 1.0)
@export var colors := [Color.RED, Color.BLUE]
@export var hit_sound: AudioStreamPlayer3D

func _ready():
	_schedule_spawn()

func _schedule_spawn():
	var t = randf_range(min_interval, max_interval)
	await get_tree().create_timer(t).timeout
	spawn_cube()
	_schedule_spawn()

func spawn_cube():
	var cube = cube_scene.instantiate()
	var color = colors.pick_random()
	cube.cube_color = color
	cube.spawner = self
	cube.global_position = Vector3(
		randf_range(spawn_x_range.x, spawn_x_range.y),
		randf_range(spawn_y_range.x, spawn_y_range.y),
		spawn_z
	)
	get_tree().current_scene.add_child(cube)

func play_hit_sound():
	if hit_sound:
		hit_sound.play()
