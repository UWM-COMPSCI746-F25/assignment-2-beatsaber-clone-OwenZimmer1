extends RigidBody3D

@export var SPEED = 1
@export var BEHIND = 1

func _ready():
	freeze = true

func _physics_process(delta):
	if global_position.z > BEHIND:
		queue_free()
	global_position.z += SPEED * delta
