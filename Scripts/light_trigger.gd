extends StaticBody2D

var light_on = false

func _ready():
	get_node("PointLight2D").enabled = light_on
	get_node("LightOccluder2D").occluder_light_mask = 1

func toggle_light():
	light_on = !light_on
	get_node("PointLight2D").enabled = light_on
	if light_on:
		get_node("LightOccluder2D").occluder_light_mask = 2
	else:
		get_node("LightOccluder2D").occluder_light_mask = 1

func _on_area_2d_area_entered(area):
	if area.is_in_group("torch"):
		print("Light entered")
		toggle_light()

func _on_area_2d_area_exited(area):
	if area.is_in_group("torch"):
		toggle_light()
