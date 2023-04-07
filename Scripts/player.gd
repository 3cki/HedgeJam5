extends CharacterBody2D

@export var tile_size = 16
@export var speed = 3
@onready var ray = $RayCast2D
var tween: Tween
var inputs = {"Walk Right": Vector2.RIGHT,
			"Walk Left": Vector2.LEFT,
			"Walk Up": Vector2.UP,
			"Walk Down": Vector2.DOWN}
var can_pick_up_torch = false
var torch

func _ready():
	tile_size = tile_size * 5
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	add_to_group("player", true)

func _unhandled_input(event):
	if tween && tween.is_running():
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)
	if event.is_action_pressed("Pick Up Torch"):
		pick_up_torch()

func move(dir):
	ray.target_position = inputs[dir] * tile_size / 5
	ray.force_raycast_update()
	rotate_sprite(dir)
	if !ray.is_colliding():
		move_tween(dir)
		

func check_torch_contact():
	can_pick_up_torch = false
	var og_rotation = ray.rotation_degrees
	for n in 4:
		ray.rotation_degrees = 90 * n
		ray.force_raycast_update()
		if ray.is_colliding():
			var hit_object = ray.get_collider()
			if hit_object.is_in_group("torch"):
				can_pick_up_torch = true
				torch = hit_object
	ray.rotation_degrees = og_rotation

func pick_up_torch():
	if can_pick_up_torch:
		print("Picking up")

func move_tween(dir):
	if tween:
		tween.kill
	tween = create_tween()
	tween.tween_property(self, "position", position + inputs[dir] * tile_size,
		0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(check_torch_contact)

func rotate_sprite(dir):
	if dir == "Walk Left":
		$Sprite.flip_h = true
	if dir == "Walk Right":
		$Sprite.flip_h = false
