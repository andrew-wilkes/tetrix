extends Controller

var tshape

func _ready():
	$Area.rect_size = get_area_size()

func get_area_size():
	return TShapes.tshapes[0].step_size * Grid.size

func start_game():
	Grid.clear()
	# Get shape
	tshape = TShapes.generate()
	# Add to grid
	Grid.add_shape_to_grid(tshape, Grid.size.x / 2, 0)
	# Show in Area
	$Area.add_child(tshape)
	tshape.move_to(4, -1)

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
	print("hard_drop")

func pause_game():
	print("Paused")

func quit_game():
	print("quit_game")

func move(x, y):
	if Grid.ok_to_move(tshape, tshape.xpos + x, tshape.ypos + y):
		tshape.move(x, y)
