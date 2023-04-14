extends Area2D

@export var speed = 100
@export var dir = Vector2.RIGHT
@export var tile_size = 16
@onready var ray = $RayCast2D
var can_check_collision = true

func _ready():
	add_to_group("enemy")
	update_ray()
		
func _process(delta):
	move(delta)

func move(delta):
	position += dir * speed * delta
	if ray.is_colliding() && can_check_collision:
		can_check_collision = false
		$Timer.start()
		dir = -dir
		update_ray()
		update_sprite_rotation()

func update_ray():
	ray.target_position = dir * (tile_size / 5)

func _on_timer_timeout():
	can_check_collision = true

func update_sprite_rotation():
	$Sprite2D.flip_h = dir.x < 0
