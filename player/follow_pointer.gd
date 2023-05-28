extends Area2D

# How quicky to follow to pointer.
@export var follow_speed: float = 10.

@export var origin: Node2D
@export var radius: float = 60 * 3 + 16
var radius_squared: float = radius * radius


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction: Vector2 = get_global_mouse_position() - global_position
	var distance: float = (global_position).distance_squared_to(origin.global_position)
	var new_position: Vector2 = global_position + (direction * delta * follow_speed)
	var new_distance: float = (new_position).distance_squared_to(origin.global_position)
	if new_distance < radius_squared || new_distance < distance:
		global_position = new_position
