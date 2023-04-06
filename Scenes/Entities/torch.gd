extends Area2D

@export var tile_size = 16
@onready var ray = $RayCast2D
var tween: Tween

func _ready():
	tile_size = tile_size * 5
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

func _on_body_entered(body):
	if body.is_in_group("player"):
		var direction = position - body.position
		direction = direction.normalized()
		if abs(direction.x) >= abs(direction.y):
			direction.x = round(direction.x)
			direction.y = 0
		else:
			direction.x = 0
			direction.y = round(direction.y)
		move(direction)

func move(dir):
	ray.target_position = dir * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		move_tween(dir)
		
func move_tween(dir):
	if tween:
		tween.kill
	tween = create_tween()
	tween.tween_property(self, "position", position + dir * tile_size,
		0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
