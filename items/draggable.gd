class_name Draggable
extends RigidBody2D

# How quicky to follow to pointer.
@export var follow_speed: float = 2500.
# Maximum distance used for scaling.
@export var max_squared_distance: float = 100.
# Amount of drag to apply to the object.
@export var drag: float = 10.
# The starting gravity scale.
var initial_gravity_scale: float = gravity_scale
@export var claw: Node2D = null


func set_claw(new_claw: Claw):
	self.claw = new_claw
	self.claw.mass += self.mass
	self.set_gravity_scale(0)
	self.lock_rotation = true


func release_claw():
	if self.claw != null:
		self.claw.mass -= self.mass
		self.claw = null

	self.set_gravity_scale(initial_gravity_scale)
	self.lock_rotation = false


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Ready!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if self.claw != null:
		# var direction: Vector2 = claw.global_position - global_position
		# var magnitude: float = clamp(direction.length_squared(), 0, max_squared_distance)
		# self.apply_central_force(delta * follow_speed * (direction.normalized() * magnitude))
		# self.apply_central_force(-drag * linear_velocity)
		self.linear_velocity = self.claw.linear_velocity
