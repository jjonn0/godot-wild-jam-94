@abstract
class_name CardScript extends Node

signal on_card_disable(state : bool)

signal on_run_right_card_script(card_script : CardScript)
signal on_disable_one_random_card(excluded_script : CardScript)

var _player_creature_data : CreatureData
var disabled : bool = false

func _ready() -> void:
	_player_creature_data = GlobalNode.game_data.get_player_creature_data()

@abstract
func on_activation() -> void

func _run_right_card_script() -> void:
	on_run_right_card_script.emit(self)

func _modify_creature_health(additive_amount : float, multiplicative_amount : float) -> void:
	_player_creature_data.temporarily_modify({"health_add" : additive_amount, "health_mult" : multiplicative_amount})

func _disable_one_random_card() -> void:
	on_disable_one_random_card.emit(self)
