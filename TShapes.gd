extends Node2D

var tshapes = []
var mass = 0.0

func _ready():
	for node in get_children():
		# Cast the node variant type to a type of TShape
		var tshape: TShape = node
		# Add up the weights
		mass += tshape.weight
		tshapes.append(tshape)
	if get_parent().name == "root":
		test()


func generate():
	var pick = randf() * mass
	for t in tshapes:
		var tshape: TShape = t
		pick -= tshape.weight
		if pick <= 0.0:
			return tshape.get_shape()
	assert(false) # Should never reach this point


func test():
	var pos = Vector2(80, 20)
	for t in get_children():
		t.rotate(false)
		t.position = pos
		pos.y += t.tsize * t.step_size + 5
