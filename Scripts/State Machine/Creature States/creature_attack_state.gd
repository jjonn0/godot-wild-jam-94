class_name CreatureAttackState extends CreatureState

@export var retreat_state : CreatureState
var slide_weight : float

func start() -> void:
	slide_weight = state_machine.one_way_slide_time

func process(_delta : float) -> void:
	if slide_weight > 0.0:
		creature.global_position = creature.global_position.lerp(creature.slide_position, state_machine.one_way_slide_time - slide_weight)
		slide_weight -= _delta
	else:
		creature.attack.emit(randf_range(creature.creature_data.current_damage_range.x, creature.creature_data.current_damage_range.y))
		_state_transition.emit(retreat_state, self)

func physics(_delta : float) -> void:
	pass

func end() -> void:
	pass
