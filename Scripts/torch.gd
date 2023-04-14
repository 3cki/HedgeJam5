extends StaticBody2D

func _ready():
	add_to_group("torch", true)
	$Area2D.add_to_group("torch", true)
