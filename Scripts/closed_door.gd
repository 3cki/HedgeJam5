extends Area2D

@onready var door = preload("res://Scenes/Entities/door.tscn")

func _ready():
	add_to_group("closed_door")


func _on_body_entered(body):
	if body.is_in_group("player_with_key"):
		var new_door = door.instantiate()
		new_door.position = position
		get_parent().add_child(new_door)
		self.queue_free()
