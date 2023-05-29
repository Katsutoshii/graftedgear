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

# For pulling mechanics (pulling self across floor)
@export var pull_start: Vector2
@export var max_pulling_y_force: float = 800
@export var min_pulling_y_force: float = 200

var collisions: Collisions = Collisions.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	self.original_collider_color = $CollisionShape2D.debug_color


func on_close():
	print("close")
	self.is_open = false
	$CollisionShape2D.debug_color = Color(1, 0, 0, 0.5)
	if self.draggable != null:
		self.draggable.set_claw(self)
	if self.collisions.has(ObjectGroup.Ground):
		self.pull_start = self.get_global_mouse_position()


func on_open():
	print("open")
	self.is_open = true
	$CollisionShape2D.debug_color = original_collider_color
	if self.draggable != null:
		self.draggable.release_claw()


func _physics_process(delta):
	if self.collisions.has(ObjectGroup.Ground) and !self.is_open:
		var direction: Vector2 = pull_start - self.get_global_mouse_position()
		var magnitude: float = clamp(direction.length_squared(), 0, self.max_squared_distance)
		self.arm.base.apply_central_force(
			delta * drag_speed * magnitude * (-direction.normalized() + 0.3 * Vector2.UP)
		)
	else:
		var direction: Vector2 = target.global_position - self.global_position
		var magnitude: float = clamp(direction.length_squared(), 0, self.max_squared_distance)
		self.apply_central_force(delta * follow_speed * (direction.normalized() * magnitude))

	self.apply_central_force(-drag * self.linear_velocity)


func _input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if self.is_open:
			self.on_close()
		else:
			self.on_open()


func _on_area_2d_body_entered(body: Node2D):
	print("_on_area_2d_body_entered: ", body.name)
	self.collisions.add(body)
	if ObjectGroup.check(body, ObjectGroup.Draggable):
		self.draggable = body as Draggable


func _on_area_2d_body_exited(body: Node2D):
	print("_on_area_2d_body_exited: ", body.name)
	self.collisions.remove(body)
	# if ObjectGroup.check(body, ObjectGroup.Draggable) and self.draggable != null:
	# 	self.draggable.release_claw()
	# 	self.draggable = null
