extends Node3D

@export var cube_scene: PackedScene
@export var spawn_distance: float = -10.0
@export var min_interval: float = 0.5
@export var max_interval: float = 2.0
@export var colors := [Color.RED, Color.BLUE]
@export var spawn_area: Vector2 = Vector2(1.5, 1.5)  # reach area in X/Y

func _ready():
	spawn_loop()

func spawn_loop() -> void:
	while true:
		spawn_cube()
		var wait_time = randf_range(min_interval, max_interval)
		await get_tree().create_timer(wait_time).timeout

func spawn_cube():
	var cube = cube_scene.instantiate()
	var color = colors.pick_random()
	cube.cube_color = color
	var x = randf_range(-spawn_area.x, spawn_area.x)
	var y = randf_range(-spawn_area.y, spawn_area.y)
	cube.position = Vector3(x, y, spawn_distance)
	add_child(cube)
