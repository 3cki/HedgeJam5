extends CharacterBody2D

@export var lives = 3
@export var tile_size = 16
@export var speed = 3
@onready var life = preload("res://Scenes/Entities/life.tscn") 
@onready var ray = $RayCast2D
var ray_size = 1
var inputs = {"Walk Right": Vector2.RIGHT, "Walk Left": Vector2.LEFT, "Walk Up": Vector2.UP, "Walk Down": Vector2.DOWN}
var tween: Tween
var torch
var torch_tween: Tween
var can_pick_up_torch = false
var picked_up_torch = false
var torch_direction = Vector2.ZERO
var torch_offset = Vector2.ZERO
var life_group
var last_position = Vector2.ZERO

func _ready():
	tile_size = tile_size * 5
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	add_to_group("player", true)
	instantiate_lives()
	last_position = position

func instantiate_lives():
	for i in lives:
		life_group = get_node("../HUD/Lives")
		var new_life = life.instantiate()
		life_group.add_child(new_life)
		new_life.position = Vector2(48 + i * 84, 48)

func _unhandled_input(event):
	if tween && tween.is_running():
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)
	if event.is_action_pressed("Pick Up Torch"):
		pick_up_torch()

func move(dir):
	if torch_movement_restrictions(dir): return
	update_ray(dir)
	rotate_sprite(dir)
	if !ray.is_colliding() || ray.get_collider().is_in_group("player_gate") && !picked_up_torch:
		last_position = position
		var new_player_position = position + inputs[dir] * tile_size
		move_tween(new_player_position)
		move_tween_torch(new_player_position)
		
func torch_movement_restrictions(dir):
	if picked_up_torch:
		if abs(torch.position.x - position.x) > abs(torch.position.y - position.y):
			if inputs[dir] == Vector2.UP || inputs[dir] == Vector2.DOWN:
				return true
		else:
			if inputs[dir] == Vector2.LEFT || inputs[dir] == Vector2.RIGHT:
				return true
		if inputs[dir] == torch_direction:
			ray_size = 2
		else:
			ray_size = 1
	else:
		ray_size = 1

func update_ray(dir):
	ray.target_position = (inputs[dir] * tile_size / 5) * ray_size
	ray.force_raycast_update()

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
	if can_pick_up_torch || picked_up_torch:
		picked_up_torch = !picked_up_torch
		torch.get_node("CollisionShape2D").disabled = picked_up_torch
		get_torch_direction()

func move_tween(new_player_position):
	if tween:
		tween.kill
	tween = create_tween()
	tween.tween_property(self, "position", new_player_position, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(check_torch_contact)

func move_tween_torch(new_player_position):
	if picked_up_torch:
		if torch_tween:
			torch_tween.kill
		torch_tween = create_tween()
		var new_torch_position = new_player_position - torch_offset
		torch_tween.tween_property(torch, "position", new_torch_position, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func rotate_sprite(dir):
	if dir == "Walk Left":
		$Sprite.flip_h = true
	if dir == "Walk Right":
		$Sprite.flip_h = false

func get_torch_direction():
	var position_difference = position - torch.position
	
	torch_offset = position_difference
	
	if abs(position_difference.x) > abs(position_difference.y):
		position_difference.x = -round(position_difference.x)
		position_difference.y = 0
	else:
		position_difference.x = 0
		position_difference.y = -round(position_difference.y)
		
	torch_direction = position_difference.normalized()

func _on_hitbox_area_entered(area):
	if area.is_in_group("enemy"):
		hit_by_enemy(area)
	if area.is_in_group("closed_door"):
		move_tween(last_position)

func hit_by_enemy(enemy):
	$CooldownTimer.stop()
	$Sprite.modulate = Color(1, 0, 0, 1)
	life_group.get_child(lives).queue_free()
	lives -= 1
	if lives <= 0:
		game_over()

func _on_cooldown_timer_timeout():
	$Sprite.modulate = Color(1, 1, 1, 1)

func _on_hitbox_area_exited(area):
	if area.is_in_group("enemy"):
		$CooldownTimer.start()

func game_over():
	get_tree().reload_current_scene()
