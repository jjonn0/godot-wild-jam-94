class_name GameData extends Resource

const PLAYER_CREATURE_DATA = preload("uid://eudcgf4f4f2w")
const BASE_ENEMY_CREATURE_DATA = preload("uid://cyoyxmodcikcd")

enum Difficulties{EASY, MEDIUM, HARD}

const EASY_SCALING : float = 1.2
const MEDIUM_SCALING : float = 1.6
const HARD_SCALING : float = 2.0

const STARTING_SPAWN_CARD_COUNT : int = 4
const STARTING_PAIR_COUNT : int = 2

var _current_difficulty : Difficulties = Difficulties.EASY
var _current_difficulty_float : float = 1.0
var _current_spawn_card_count : int = STARTING_SPAWN_CARD_COUNT
var _current_pair_count : int = STARTING_PAIR_COUNT
var _player_creature_data : CreatureData = PLAYER_CREATURE_DATA
var _enemy_creature_data : CreatureData = BASE_ENEMY_CREATURE_DATA

## Resets stats back to max.
func reset_stats() -> void:
	_player_creature_data.reset()
	_enemy_creature_data.reset()

func set_current_difficulty(new_difficulty : Difficulties) -> void:
	_current_difficulty = new_difficulty

func get_current_difficulty() -> Difficulties:
	return _current_difficulty

func set_current_difficulty_float(new_float : float) -> void:
	_current_difficulty_float = new_float

func get_current_difficulty_float() -> float:
	return _current_difficulty_float

func set_current_spawn_card_count(new_count : int) -> void:
	_current_spawn_card_count = new_count

func get_current_spawn_card_count() -> int:
	return _current_spawn_card_count

func set_current_pair_count(new_count : int) -> void:
	_current_pair_count = new_count

func get_current_pair_count() -> int:
	return _current_pair_count

func get_player_creature_data() -> CreatureData:
	return _player_creature_data

func get_enemy_creature_data() -> CreatureData:
	return _enemy_creature_data

func scale_difficulty() -> void:
	match _current_difficulty:
		Difficulties.EASY:
			_current_difficulty_float *= EASY_SCALING
		Difficulties.MEDIUM:
			_current_difficulty_float *= MEDIUM_SCALING
		Difficulties.HARD:
			_current_difficulty_float *= HARD_SCALING

func scale_creature(creature_data : CreatureData) -> void:
	var difficulty_float : float = _current_difficulty_float
	creature_data.start_health *= difficulty_float
	creature_data.damage_range *= difficulty_float
	creature_data.attack_speed /= difficulty_float * 0.8
	creature_data.reset()
