extends RigidBody2D

# Whether the item is selected or not.
var selected: bool = false
# How quicky to follow to pointer.
@export var follow_speed: float = 2500.
# Maximum distance used for scaling.
@export var max_squared_distance: float = 100.
# Amount of drag to apply to the object.
@export var drag: float = 10.
# The starting gravity scale.
var initial_gravity_scale: float = gravity_scale


func on_select():
	selected = true
	print("on_select")
	set_gravity_scale(0)


func on_deselect():
	selected = false
	print("on_deselect")
	set_gravity_scale(initial_gravity_scale)


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Ready!")
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if selected:
		var direction: Vector2 = get_global_mouse_position() - global_position
		var magnitude: float = clamp(direction.length_squared(), 0, max_squared_distance)
		apply_central_force(delta * follow_speed * (direction.normalized() * magnitude))
		apply_central_force(-drag * linear_velocity)


func _input(event):
	if selected and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		on_deselect()

func _on_input_event(_viewport, _event, _shape_idx):
	if not selected and Input.is_action_just_pressed("click"):
		on_select()


func _on_body_entered(body: Node):
	print("_on_body_entered: ", body.name)


func _on_body_exited(body: Node):
	print("_on_body_exited: ", body.name)
