extends Node2D

class_name Controller

# EVENTS
enum { TIMEOUT_1, TIMEOUT_2 }

# STATES
enum { READY, PAUSED, PLAYING, DEFAULT, LEFT, RIGHT, FAST }

export var side_move_delay = 1.0
export var side_move_period = 0.2
export var soft_drop_period = 0.2
export var tick_period = 1.0

var game_state = READY
var side_moving_state = DEFAULT
var down_moving_speed = DEFAULT

func handle_state(event_code, pressed):
	match game_state:
		READY:
			if event_code == KEY_SPACE and pressed:
				$Timer1.start(tick_period)
				start_game()
				game_state = PLAYING
			if event_code == KEY_ESCAPE and pressed:
				quit_game()
		PAUSED:
			if event_code == KEY_SPACE and pressed:
				$Timer1.start(tick_period)
				resume_game()
				game_state = PLAYING
			if event_code == KEY_ESCAPE and pressed:
				reset_game()
				game_state = READY
		PLAYING:
			match event_code:
				KEY_LEFT:
					if pressed:
						$Timer2.start(side_move_delay)
						side_moving_state = LEFT
						start_moving_left()
					else:
						stop_moving_left()
						side_moving_state = DEFAULT
				KEY_RIGHT:
					if pressed:
						$Timer2.start(side_move_delay)
						side_moving_state = RIGHT
						start_moving_right()
					else:
						stop_moving_right()
						side_moving_state = DEFAULT
				KEY_Z:
					try_rotate_left()
				KEY_X:
					try_rotate_right()
				KEY_C:
					hold_piece()
				KEY_SPACE:
					if pressed:
						hard_drop()
				KEY_DOWN:
					if pressed:
						$Timer1.start(soft_drop_period)
						down_moving_speed = FAST
					else:
						down_moving_speed = DEFAULT
				KEY_ESCAPE:
					$Timer1.stop()
					game_state = PAUSED
					pause_game()
				TIMEOUT_1:
					if down_moving_speed == FAST:
						$Timer1.start(soft_drop_period)
					else:
						$Timer1.start(tick_period)
					move_down()
				TIMEOUT_2:
					match side_moving_state:
						LEFT:
							$Timer2.start(side_move_period)
							fast_move_left()
						RIGHT:
							$Timer2.start(side_move_period)
							fast_move_right()

var keys = {}

func _unhandled_input(event):
	if event is InputEventKey:
		# Add new key to dictionary
		if not keys.has(event.scancode):
			keys[event.scancode] = false
		# Respond to change in key state (pressed or released)
		if event.pressed != keys[event.scancode]:
			keys[event.scancode] = event.pressed
			handle_state(event.scancode, event.pressed)

func start_game():
	print("start_game")

func resume_game():
	print("resume_game")

func reset_game():
	print("reset_game")

func start_moving_left():
	print("start_moving_left")

func stop_moving_left():
	print("stop_moving_left")

func fast_move_left():
	print("fast_move_left")

func fast_move_right():
	print("fast_move_right")

func start_moving_right():
	print("start_moving_right")

func stop_moving_right():
	print("stop_moving_right")

func move_down():
	print("move_down")

func try_rotate_left():
	print("try_rotate_left")

func try_rotate_right():
	print("try_rotate_right")

func hold_piece():
	print("hold_piece")

func hard_drop():
	print("hard_drop")

func pause_game():
	print("Paused")

func quit_game():
	print("quit_game")

func _on_Timer1_timeout():
	handle_state(TIMEOUT_1, false)

func _on_Timer2_timeout():
	handle_state(TIMEOUT_2, false)
