class_name TransfusionScript extends CardScript

func on_activation() -> void:
	_modify_creature_health(0.0, 0.95)
