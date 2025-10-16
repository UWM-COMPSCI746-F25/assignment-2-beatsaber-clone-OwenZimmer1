# CubeSpawner.gd
extends Node3D

@export var cube_scene: PackedScene
@export var min_interval: float = 0.5
@export var max_interval: float = 2.0
@export var spawn_z: float = -12.0
@export var spawn_x_range: Vector2 = Vector2(-1.2, 1.2)  # left/right range (meters)
@export var spawn_y_range: Vector2 = Vector2(0.6, 2.0)   # vertical range (meters)
@export var spawn_speed: float = 6.0
@export var right_color_name: String = "right"
@export var left_color_name: String = "left"

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	_start_timer()

func _start_timer():
	var t = rng.randf_range(min_interval, max_interval)
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = t
	add_child(timer)
	timer.timeout.connect(_on_spawn_timer_timeout)
	timer.start()

func _on_spawn_timer_timeout():
	spawn_cube()
	_start_timer()

func spawn_cube():
	if not cube_scene:
		return
	var c = cube_scene.instantiate()
	# random x,y within range
	var x = rng.randf_range(spawn_x_range.x, spawn_x_range.y)
	var y = rng.randf_range(spawn_y_range.x, spawn_y_range.y)
	c.global_transform.origin = Vector3(x, y, spawn_z)

	# choose color randomly
	if rng.randf() < 0.5:
		c.color_name = right_color_name
	else:
		c.color_name = left_color_name

	# ensure speed is set
	if c.has_variable("speed"):
		c.speed = spawn_speed

	get_tree().root.add_child(c)  # or add to a dedicated world Node
