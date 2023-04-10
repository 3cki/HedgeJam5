extends Area2D

func _ready():
	add_to_group("key")


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.add_to_group("player_with_key")
		queue_free()
