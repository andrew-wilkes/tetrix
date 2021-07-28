extends Node2D

class_name Controller

# EVENTS
enum { TIMEOUT_1, TIMEOUT_2 }

# STATES
enum { READY, PAUSED, PLAYING }

var state = READY

func handle_state(code, pressed):
	match state:
		READY:
			if code == KEY_SPACE and pressed:
				start_game()
				state = PLAYING
		PAUSED:
			if code == KEY_SPACE and pressed:
				resume_game()
				state = PLAYING
		PLAYING:
			match code:
				KEY_LEFT:
					if pressed:
						start_moving_left()
					else:
						stop_moving_left()
				KEY_RIGHT:
					if pressed:
						start_moving_right()
					else:
						stop_moving_right()
				KEY_Z:
					pass
				KEY_X:
					pass
				KEY_C:
					pass
				KEY_SPACE:
					pass
				KEY_DOWN:
					pass
				KEY_ESCAPE:
					pass

func _unhandled_input(event):
	if event is InputEventKey:
		handle_state(event.scancode, event.pressed)

func start_game():
	pass

func resume_game():
	pass

func start_moving_left():
	pass

func stop_moving_left():
	pass

func start_moving_right():
	pass

func stop_moving_right():
	pass

func _on_Timer_timeout():
	handle_state(TIMEOUT_1, false)

func _on_Timer2_timeout():
	handle_state(TIMEOUT_2, false)
