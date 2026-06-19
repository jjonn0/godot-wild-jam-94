class_name CreatureStateMachine extends StateMachine

@export var creature : Creature
@export var one_way_slide_time : float = 0.5

func scan_for_states() -> void:
	for child in get_children():
		if child is CreatureState:
			child._state_transition.connect(state_transition)
			child.state_machine = self
			child.creature = creature
			states.append(child)
	if starting_state:
		current_state = starting_state
		current_state.start()
