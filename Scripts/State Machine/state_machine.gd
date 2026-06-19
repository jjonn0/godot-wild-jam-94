class_name StateMachine extends Node

@export var starting_state : State

var states : Array[State]
var current_state : State

func _ready() -> void:
	scan_for_states()

func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics(delta)

func scan_for_states() -> void:
	for child in get_children():
		if child is State:
			child._state_transition.connect(state_transition)
			child.state_machine = self
			states.append(child)
	if starting_state:
		current_state = starting_state
		current_state.start()

func state_transition(new_state : State, calling_state : State) -> void:
	if not new_state:
		push_error("[%s]: No new state given." % self)
		return
	if not calling_state:
		push_error("[%s]: No calling state given." % self)
		return
	if calling_state != current_state:
		push_error("[%s]: Current state does not match calling state." % self)
		return
	current_state.end()
	current_state = new_state
	current_state.start()
