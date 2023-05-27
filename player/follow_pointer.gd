extends Node2D

# How quicky to follow to pointer.
@export var follow_speed: float = 10.


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var direction: Vector2 = get_global_mouse_position() - global_position
	global_position += direction * delta * follow_speed
