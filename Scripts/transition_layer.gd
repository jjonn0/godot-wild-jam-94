class_name TransitionLayer extends CanvasLayer

signal screen_covered()
signal screen_cleared()

@export var static_overlay : ColorRect

func static_overlay_cover(transition_time : float, transition_steps : int) -> void:
	static_overlay.color = Color(0.0, 0.0, 0.0, 0.0)
	static_overlay.show()
	var new_timer : TransitionTimer = TransitionTimer.new(_static_overlay_cover_finished, transition_time, transition_steps)
	new_timer.new_transition_value.connect(_new_static_overlay_value)
	add_child(new_timer)
	new_timer.start_timer()

func _static_overlay_cover_finished() -> void:
	screen_covered.emit()

func static_overlay_clear(transition_time : float, transition_steps : int) -> void:
	static_overlay.color = Color(0.0, 0.0, 0.0, 1.0)
	var new_timer : TransitionTimer = TransitionTimer.new(_static_overlay_clear_finished, transition_time, transition_steps)
	new_timer.new_transition_value.connect(_new_static_overlay_value_inverse)
	add_child(new_timer)
	new_timer.start_timer()

func _static_overlay_clear_finished() -> void:
	screen_cleared.emit()
	static_overlay.hide()

func _new_static_overlay_value(value : float) -> void:
	static_overlay.color = Color(0.0, 0.0, 0.0, value)

func _new_static_overlay_value_inverse(value : float) -> void:
	static_overlay.color = Color(0.0, 0.0, 0.0, 1.0 - value)

class TransitionTimer extends Timer:
	signal new_transition_value(value : float)
	
	var _transition_finished_callable : Callable
	var _total_transition_time : float
	var _transition_steps : int
	var _current_step : int
	
	func _init(transition_finished_callable : Callable, total_transition_time : float, transition_steps : int) -> void:
		_transition_finished_callable = transition_finished_callable
		_total_transition_time = total_transition_time
		_transition_steps = transition_steps
		_current_step = 0
		timeout.connect(_on_timeout)
	
	func start_timer() -> void:
		start(_calculate_time())
	
	func _calculate_time() -> float:
		return _total_transition_time / _transition_steps
	
	func _on_timeout() -> void:
		new_transition_value.emit(float(_current_step) / float(_transition_steps))
		if _current_step == _transition_steps:
			_transition_finished_callable.call()
			queue_free()
		_current_step += 1
