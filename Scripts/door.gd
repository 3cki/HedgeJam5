extends Area2D

@export var next_scene: PackedScene
var can_switch_scene = false

func _ready():
	add_to_group("door")

func _on_body_entered(body):
	if body.is_in_group("player") && can_switch_scene:
		get_tree().change_scene_to_packed(next_scene)

func _on_timer_timeout():
	can_switch_scene = true
