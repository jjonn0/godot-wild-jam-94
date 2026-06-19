class_name FightHUD extends Control

const _HEALTH_BAR_UPDATE_WEIGHT : float = 4.0

@export var player_health_bar : ProgressBar
@export var enemy_health_bar : ProgressBar
@onready var player_stat_list: VBoxContainer = $PlayerStatList
@onready var enemy_stat_list: VBoxContainer = $EnemyStatList

func _ready() -> void:
	player_stat_list.update_stats(GlobalNode.game_data.get_player_creature_data())
	enemy_stat_list.update_stats(GlobalNode.game_data.get_enemy_creature_data())

func update_data(player_data : CreatureData, enemy_data : CreatureData, delta : float) -> void:
	player_health_bar.max_value = player_data.start_health
	enemy_health_bar.max_value = enemy_data.start_health
	player_health_bar.value = lerp(player_health_bar.value, player_data.current_health, delta * _HEALTH_BAR_UPDATE_WEIGHT)
	enemy_health_bar.value = lerp(enemy_health_bar.value, enemy_data.current_health, delta * _HEALTH_BAR_UPDATE_WEIGHT)
