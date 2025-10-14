extends Area3D

@export var sword_color: Color = Color.BLUE
@export var controller_path: NodePath
@onready var controller: XRController3D = get_node(controller_path)
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var audio_hit: AudioStreamPlayer3D = $AudioStreamPlayer3D

var sword_active: bool = true
const LENGTH := 1.0

func _ready():
	_update_visuals()

func _process(_delta):
	if controller:
		# Example: Right hand = "ax_button", Left hand = "x_button"
		if controller.is_button_pressed("ax_button") or controller.is_button_pressed("x_button"):
			sword_active = !sword_active
			_update_visuals()
			await get_tree().create_timer(0.25).timeout  # debounce input

func _update_visuals():
	mesh.visible = sword_active
	collision.disabled = not sword_active
	if mesh.material_override:
		mesh.material_override.albedo_color = sword_color

func _on_body_entered(body):
	if not sword_active:
		return
	if body.has_method("on_hit_by_sword"):
		body.on_hit_by_sword(sword_color)
		audio_hit.play()
