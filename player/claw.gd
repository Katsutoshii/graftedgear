class_name Claw
extends RigidBody2D

@export var is_open: bool = true
@export var arm: Arm = null
@export var draggable: Draggable = null
@export var original_collider_color: Color

# How quicky to follow to pointer.
@export var follow_speed: float = 2500.
@export var drag_speed: float = 1000.
# Maximum distance used for scaling.
@export var max_squared_distance: float = 100.
# Amount of drag to apply to the object.
@export var drag: float = 10.
@export var target: Node2D
@export var pulling: bool
@export var max_pulling_y_force: float = 800
@export var min_pulling_y_force: float = 200


# Called when the node enters the scene tree for the first time.
func _ready():
	self.original_collider_color = $CollisionShape2D.debug_color


func on_close():
	print("close")
	self.is_open = false
	$CollisionShape2D.debug_color = Color(1, 0, 0, 0.5)
	if self.draggable != null:
		self.draggable.set_claw(self)


func on_open():
	print("open")
	self.is_open = true
	$CollisionShape2D.debug_color = original_collider_color
	if self.draggable != null:
		self.draggable.release_claw()


func _physics_process(delta):
	var direction: Vector2 = target.global_position - self.global_position
	var magnitude: float = clamp(direction.length_squared(), 0, self.max_squared_distance)
	if self.pulling and !self.is_open:
		# direction.y = clamp(direction.y, -800 * delta, -200 * delta)
		self.arm.base.apply_central_force(
			delta * drag_speed * magnitude * (-direction.normalized() + 0.3 * Vector2.UP)
		)
		self.arm.base.apply_central_force(-drag * linear_velocity)
	else:
		self.apply_central_force(delta * follow_speed * (direction.normalized() * magnitude))
		self.apply_central_force(-drag * linear_velocity)


func _input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if self.is_open:
			self.on_close()
		else:
			self.on_open()


func _on_area_2d_body_entered(body: Node2D):
	print("_on_area_2d_body_entered: ", body.name)
	if !self.is_open:
		return
	if body.is_in_group(Groups.Draggable):
		self.draggable = body as Draggable
	elif body.is_in_group(Groups.Ground):
		self.pulling = true


func _on_area_2d_body_exited(body: Node2D):
	print("_on_area_2d_body_exited: ", body.name)
	if body.is_in_group(Groups.Draggable) and self.draggable != null:
		self.draggable.release_claw()
		self.draggable = null
	elif body.is_in_group(Groups.Ground):
		self.pulling = false
