extends Node

func _ready():
	var ts = $TShapes
	var pos = Vector2(80, 20)
	for t in ts.get_children():
		t.rotate(false)
		t.position = pos
		pos.y += t.tsize * t.step_size + 5
