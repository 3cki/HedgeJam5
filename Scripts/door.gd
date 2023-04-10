extends Area2D

@export var next_scene: PackedScene

func _ready():
	add_to_group("door")

func _on_body_entered(body):
	if body.is_in_group("player"):
		get_tree().change_scene_to_packed(next_scene)
