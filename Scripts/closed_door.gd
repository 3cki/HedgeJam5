extends Area2D

@export var next_scene: PackedScene
@onready var door = preload("res://Scenes/Entities/door.tscn")

func _ready():
	add_to_group("closed_door")

func _on_body_entered(body):
	if body.is_in_group("player_with_key"):
		$AudioStreamPlayer2D.play()
		var new_door = door.instantiate()
		new_door.position = position
		new_door.next_scene = next_scene
		get_parent().add_child(new_door)
		self.visible = false
		$CollisionShape2D.disabled = true


func _on_audio_stream_player_2d_finished():
	call_deferred("queue_free")
