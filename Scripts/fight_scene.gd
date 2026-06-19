extends Node2D

const CREATURE = preload("uid://3ilu2mnmmjj")

enum FightPhase{ENTRANCE, FIGHT, END}

@export var player_creature_follow : PathFollow2D
@export var enemy_creature_follow : PathFollow2D
@onready var win_decide_windup: Timer = $WinDecideWindup

var player_creature_ref : Creature
var enemy_creature_ref : Creature
var dead_creatures : Array[Creature] = []

var _current_fight_phase : FightPhase
var _entrance_time : float = 2.0

func _ready() -> void:
	GlobalNode.music_manager.play_fight_scene_music()
	player_creature_ref = instantiate_new_creature(GlobalNode.game_data.get_player_creature_data())
	player_creature_ref.player_owned = true
	enemy_creature_ref = instantiate_new_creature(GlobalNode.game_data.get_enemy_creature_data())
	enemy_creature_ref.player_owned = false
	player_creature_follow.add_child(player_creature_ref)
	enemy_creature_follow.add_child(enemy_creature_ref)
	_current_fight_phase = FightPhase.ENTRANCE

func _process(delta: float) -> void:
	if _current_fight_phase == FightPhase.ENTRANCE:
		player_creature_follow.progress_ratio += delta / _entrance_time
		enemy_creature_follow.progress_ratio += delta / _entrance_time
		if player_creature_follow.progress_ratio == 1.0 and enemy_creature_follow.progress_ratio == 1.0:
			initiate_fight()
	if GlobalNode.transition_manager.current_gui_scene is FightHUD:
		GlobalNode.transition_manager.current_gui_scene.update_data(GlobalNode.PLAYER_CREATURE_DATA, enemy_creature_ref.creature_data, delta)

func instantiate_new_creature(creature_data : CreatureData = CreatureData.new()) -> Creature:
	var new_creature : Creature = CREATURE.instantiate()
	new_creature.creature_data = creature_data
	new_creature.process_mode = Node.PROCESS_MODE_DISABLED
	return new_creature

func prepare_creature(creature : Creature, opposing_creature : Creature) -> void:
	creature.reset()
	creature.attack.connect(opposing_creature.take_damage)
	creature.on_death.connect(declare_winner)
	creature.process_mode = Node.PROCESS_MODE_INHERIT
	creature.state_machine.current_state.start()

func initiate_fight() -> void:
	_current_fight_phase = FightPhase.FIGHT
	prepare_creature(player_creature_ref, enemy_creature_ref)
	prepare_creature(enemy_creature_ref, player_creature_ref)

func declare_winner(dead_creature : Creature) -> void:
	dead_creatures.append(dead_creature)
	if win_decide_windup.is_stopped():
		win_decide_windup.start()

func stop_fight() -> void:
	GlobalNode.game_data.scale_difficulty()
	player_creature_ref.state_machine.process_mode = Node.PROCESS_MODE_DISABLED
	enemy_creature_ref.state_machine.process_mode = Node.PROCESS_MODE_DISABLED
	GlobalNode.transition_manager.transition_to_gene_editor()

func _on_win_decide_windup_timeout() -> void:
	stop_fight()
