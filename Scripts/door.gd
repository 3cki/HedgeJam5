extends Area2D

func _ready():
	add_to_group("door")


func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Player entered")
