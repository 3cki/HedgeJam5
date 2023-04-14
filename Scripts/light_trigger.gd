extends StaticBody2D

@export var group_name = "light_trigger_group"
var light_on = false

func _ready():
	get_node("PointLight2D").enabled = light_on
	get_node("LightOccluder2D").occluder_light_mask = 1

func toggle_light():
	light_on = !light_on	
	get_node("PointLight2D").enabled = light_on
	if light_on:
		get_node("LightOccluder2D").occluder_light_mask = 2
		$Sprite2D.modulate = Color(1, 1, 0, 1);
		for el in get_tree().get_nodes_in_group(group_name):
			el.set_process_mode(PROCESS_MODE_DISABLED)
			el.visible = false
	else:
		get_node("LightOccluder2D").occluder_light_mask = 1
		$Sprite2D.modulate = Color(1, 1, 1, 1);
		for el in get_tree().get_nodes_in_group(group_name):
			el.set_process_mode(PROCESS_MODE_ALWAYS)
			el.visible = true

func _on_area_2d_area_entered(area):
	if area.is_in_group("torch"):
		toggle_light()

func _on_area_2d_area_exited(area):
	if area.is_in_group("torch"):
		toggle_light()