class_name CreatureRetreatState extends CreatureState

@export var windup_state : CreatureState
var slide_weight : float

func start() -> void:
	slide_weight = state_machine.one_way_slide_time

func process(_delta : float) -> void:
	if slide_weight > 0.0:
		creature.global_position = creature.global_position.lerp(creature.return_position, state_machine.one_way_slide_time - slide_weight)
		slide_weight -= _delta
	else:
		_state_transition.emit(windup_state, self)

func physics(_delta : float) -> void:
	pass

func end() -> void:
	pass
