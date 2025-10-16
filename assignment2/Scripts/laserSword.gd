# LaserSword.gd
extends Node3D

@export var is_right: bool = false
@export var length: float = 1.0             # ~1 meter
@export var thickness: Vector3 = Vector3(0.02, 0.02, 1.0)
@export var laser_color: Color = Color(0.0, 0.4, 1.0, 1.0)
@export var laser_off_color: Color = Color(0.1, 0.1, 0.1, 0.0)
@export var input_toggle_left: String = "toggle_laser_right" # set per-instance

@onready var line3d: CSGCylinder3D = $CSGCylinder3D
@onready var area: Area3D = $Area3D
@onready var shape: CollisionShape3D = $Area3D/CollisionShape3D

var enabled: bool = false

func _ready():
	# setup line geometry
	line3d.clear_points()
	line3d.add_point(Vector3.ZERO)
	line3d.add_point(Vector3(0, 0, -length))
	# set a simple material color for the line (use immediate color for visibility)
	var mat = StandardMaterial3D.new()
	mat.albedo_color = laser_color
	line3d.material = mat

	# setup collision shape as a thin box stretched along -Z
	var box = BoxShape3D.new()
	box.size = Vector3(0.02, 0.02, length)
	shape.shape = box
	# position the area so it covers the length (Area3D origin is at controller)
	area.transform = Transform3D(Basis.IDENTITY, Vector3(0, 0, -length/2.0))

	# disable by default
	set_enabled(false)
	# connect to area entered signal
	area.body_entered.connect(_on_area_body_entered)

func set_enabled(on: bool) -> void:
	enabled = on
	line3d.visible = on
	area.monitoring = on
	area.monitorable = on

func _process(delta):
	# toggle on button press
	if Input.is_action_just_pressed(input_toggle_left):
		set_enabled(not enabled)

func _on_area_body_entered(body: Node) -> void:
	# when sword area overlaps a cube, request the cube to handle it
	# we expect Cube nodes to have a "try_hit(color_name)" method or "on_hit_from_sword(color)"
	if not enabled:
		return
	if body.has_method("try_hit"):
		var sword_color_name = Color.BLUE
		body.try_hit(sword_color_name)
	else:
		# fallback: look for node property
		if "color_name" in body:
			var c = body.color_name
			var sword_color_name = Color.BLUE
			if c == sword_color_name and body.has_method("destroy_by_sword"):
				body.destroy_by_sword()
