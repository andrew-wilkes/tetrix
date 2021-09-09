extends Controller

var tshape
var ok

func _ready():
	$Area.rect_size = get_area_size()

func get_area_size():
	return TShapes.tshapes[0].step_size * Grid.size

func start_game():
	Grid.clear()
	add_new_shape()

func add_new_shape():
	# Get shape
	tshape = TShapes.generate()
	# Show in Area
	$Area.add_child(tshape)
	tshape.move_to(4, -2)

func resume_game():
	print("resume_game")

func reset_game():
	print("reset_game")

func start_moving_left():
	move(-1, 0)

func stop_moving_left():
	print("stop_moving_left")

func fast_move_left():
	move(-1, 0)

func fast_move_right():
	move(1, 0)

func start_moving_right():
	move(1, 0)

func stop_moving_right():
	print("stop_moving_right")

func move_down():
	move(0, 1)
	if not ok:
		embed_shape()

func try_rotate_left():
	tshape.rotate()
	if not Grid.ok_to_move(tshape, tshape.xpos, tshape.ypos):
		tshape.rotate(false)

func try_rotate_right():
	tshape.rotate(false)
	if not Grid.ok_to_move(tshape, tshape.xpos, tshape.ypos):
		tshape.rotate()

func hold_piece():
	print("hold_piece")

func hard_drop():
	ok = true
	while ok:
		move(0, 1)
	embed_shape()

func pause_game():
	timer1.stop()
	game_state = PAUSED
	print("Paused")

func quit_game():
	print("quit_game")

func move(x, y):
	ok = Grid.ok_to_move(tshape, tshape.xpos + x, tshape.ypos + y)
	if ok:
		tshape.move(x, y)

func embed_shape():
	Grid.add_shape_to_grid(tshape, tshape.xpos, tshape.ypos)
	tshape.reparent_tiles($Area)
	tshape.queue_free()
	var full_rows = Grid.get_full_rows()
	var num_rows = full_rows.size()
	if num_rows > 0:
		Grid.remove_rows(full_rows)
	#pause_game()
	add_new_shape()
