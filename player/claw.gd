extends Bone2D

var is_open: bool = true
var original_collider_color: Color


func on_close():
	print("close")
	is_open = false
	$Area2D/CollisionShape2D.debug_color = Color(1, 0, 0, 0.5)


func on_open():
	print("open")
	is_open = true
	$Area2D/CollisionShape2D.debug_color = original_collider_color


# Called when the node enters the scene tree for the first time.
func _ready():
	original_collider_color = $Area2D/CollisionShape2D.debug_color


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
