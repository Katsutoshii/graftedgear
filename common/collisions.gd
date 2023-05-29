class_name Collisions

var collisions: Array[int] = []


func _init():
	self.collisions.resize(ObjectGroup.COUNT)
	self.collisions.fill(0)


func add(body: Node2D):
	for group in body.get_groups():
		self.collisions[ObjectGroup[group]] += 1


func remove(body: Node2D):
	for group in body.get_groups():
		self.collisions[ObjectGroup[group]] -= 1


func has(group: int):
	return self.collisions[group] > 0
