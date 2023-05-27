extends RigidBody2D

var is_open: bool = true
var original_collider_color: Color

# How quicky to follow to pointer.
@export var follow_speed: float = 2500.
# Maximum distance used for scaling.
@export var max_squared_distance: float = 100.
# Amount of drag to apply to the object.
@export var drag: float = 10.
@export var target: Node2D
const RADIUS_SQUARED = (64 * 3 + 16) ^ 2


func on_close():
	print("close")
	is_open = false
	$CollisionShape2D.debug_color = Color(1, 0, 0, 0.5)


func on_open():
	print("open")
	is_open = true
	$CollisionShape2D.debug_color = original_collider_color


# Called when the node enters the scene tree for the first time.
func _ready():
	original_collider_color = $CollisionShape2D.debug_color


func _physics_process(delta):
	var direction: Vector2 = target.global_position - global_position
	var magnitude: float = clamp(direction.length_squared(), 0, max_squared_distance)
	apply_central_force(delta * follow_speed * (direction.normalized() * magnitude))
	apply_central_force(-drag * linear_velocity)


func _input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if is_open:
			on_close()
		else:
			on_open()


func _on_area_2d_body_entered(body: Node2D):
	print("Body entered: ", body.name)
	# _body.get_parent()


func _on_area_2d_body_exited(_body: Node2D):
	pass
