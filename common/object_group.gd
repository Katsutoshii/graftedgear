class_name ObjectGroup
enum { Claw, Draggable, Ground }

const COUNT = 3


static func check(body: Node2D, group: int):
	var name: StringName = ObjectGroup.keys()[group]
	return body.is_in_group(name)
