extends Area2D

@export var tile_size = 16
@export var speed = 3
@onready var ray = $RayCast2D
var tween: Tween
var inputs = {"Walk Right": Vector2.RIGHT,
			"Walk Left": Vector2.LEFT,
			"Walk Up": Vector2.UP,
			"Walk Down": Vector2.DOWN}


func _ready():
	tile_size = tile_size * 5
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	rotate_sprite(dir)
	if !ray.is_colliding():
		move_tween(dir)

func move_tween(dir):
	if tween:
		tween.kill
	tween = create_tween()
	tween.tween_property(self, "position", position + inputs[dir] * tile_size,
		0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func rotate_sprite(dir):
	if dir == "Walk Left":
		$Sprite.flip_h = true
	if dir == "Walk Right":
		$Sprite.flip_h = false
