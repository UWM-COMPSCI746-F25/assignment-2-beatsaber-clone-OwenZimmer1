extends Area3D

@export var sword_color: Color = Color.BLUE
@export var controller_path: NodePath
@onready var controller: XRController3D = get_node(controller_path)
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var audio_hit: AudioStreamPlayer3D = $AudioStreamPlayer3D

var sword_active := true

func _ready():
	_update_visuals()
	connect("body_entered", Callable(self, "_on_body_entered"))

var last_button_state := false

func _process(_delta):
	if controller:
		var pressed = controller.is_button_pressed("ax_button")
		if pressed and not last_button_state:
			print("button pressed")
			_toggle_sword()
		last_button_state = pressed

func _toggle_sword():
	sword_active = !sword_active
	_update_visuals()
	audio_hit.play() # optional feedback


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
		
func _input(event):
	if event.is_action_pressed("toggle_sword"):
		_toggle_sword()
