class_name CreatureWindupState extends CreatureState

@export var creature_attack_state : CreatureState
@export var windup_timer : Timer

func start() -> void:
	if not windup_timer.timeout.is_connected(_on_windup_timer_end):
		windup_timer.timeout.connect(_on_windup_timer_end)
	if creature.creature_data.current_health <= 0.0:
		return
	windup_timer.start(creature.creature_data.attack_speed)

func process(_delta : float) -> void:
	pass

func physics(_delta : float) -> void:
	pass

func end() -> void:
	pass

func _on_windup_timer_end() -> void:
	_state_transition.emit(creature_attack_state, self)
