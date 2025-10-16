extends XRController3D

@export var saber: RayCast3D
@export var primary_button := "ax_button" # “a_button” or “x_button” depending on side

func _process(_delta):
	if get_input(primary_button):  # Button pressed
		if saber:
			saber.toggle_laser()
