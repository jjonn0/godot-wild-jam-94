class_name MedicineScript extends CardScript

func on_activation() -> void:
	_modify_creature_health(0.1 * GlobalNode.game_data.get_player_creature_data().start_health, 1.0)
