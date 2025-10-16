extends Node3D

@export var spawn_x_range: Vector2 = Vector2(-1.2, 1.2)
@export var spawn_y_range: Vector2 = Vector2(.2, 2)
@export var spawn_z: float = -10
@export var min_interval: float = 0.5
@export var max_interval: float = 2.0
@export var spawn_speed: float = 6.0
@export var right_color_name: String = "right"
@export var left_color_name: String = "left"
@export var count: int = 0

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
	var box = preload("res://Cube.tscn").instantiate()
	
	var c = rng.randi_range(0, 1)
	if c == 1:
		box.name = right_color_name
		#box.collision_layer = 7
	else:
		box.name = left_color_name
		#box.collision_layer = 6
	count += 1
	box.name += str(count)
	
	var x = rng.randf_range(spawn_x_range.x, spawn_x_range.y)
	var y = rng.randf_range(spawn_y_range.x, spawn_y_range.y)
	box.global_transform.origin = Vector3(x, y, spawn_z)
	
	add_child(box)
