@abstract
class_name CardScript extends Node

signal on_run_right_card_script(card_script : CardScript)

## Refer to CardScript for documentation on how to use.
@abstract
func on_activation() -> void

func _run_right_card_script() -> void:
	on_run_right_card_script.emit(self)

func _modify_creature_health(additive_amount : float, multiplicative_amount : float) -> void:
	GlobalNode.player_creature_data.temporarily_modify({"health_add" : additive_amount, "health_mult" : multiplicative_amount})
