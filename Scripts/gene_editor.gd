extends Control

const CARD_PATH : StringName = "res://Scenes/Cards/"

@onready var card_end_box: ReferenceRect = $CardEndBox
@onready var card_start_box: ReferenceRect = $CardStartBox
@onready var dna_spawn_point: Marker2D = $DNASpawnPoint
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var card_spawn_delay: Timer = $CardSpawnDelay

var potential_cards : Array[PackedScene] = []
var spawned_cards : Array[GeneCard] = []
var dna_strand : DNAStrand

func _enter_tree() -> void:
	_load_card_scenes()

func _ready() -> void:
	animation_player.play("gene_editor_open")

func _spawn_dna_strand() -> void:
	dna_strand = DNAStrand.new()
	dna_strand.global_position = dna_spawn_point.global_position
	dna_strand.new_snap_marker.connect(_on_new_snap_position)
	add_child(dna_strand)

func _load_card_scenes() -> void:
	potential_cards = []
	var dir : DirAccess = DirAccess.open(CARD_PATH)
	if dir:
		for file in dir.get_files():
			if file.ends_with(".tscn"):
				var new_scene : PackedScene = load(CARD_PATH + file)
				potential_cards.append(new_scene)

func _get_rand_position_in_rect(rect : Rect2) -> Vector2:
	var return_position : Vector2
	return_position.x = randf_range(rect.position.x, rect.end.x)
	return_position.y = randf_range(rect.position.y, rect.end.y)
	return return_position

func _spawn_new_card() -> void:
	var new_card_scene : PackedScene = potential_cards[randi() % potential_cards.size()]
	var new_card : GeneCard = new_card_scene.instantiate()
	new_card.spawn_and_move(_get_rand_position_in_rect(card_start_box.get_rect()), _get_rand_position_in_rect(card_end_box.get_rect()))
	new_card.global_position = card_start_box.get_rect().end
	add_child(new_card)
	new_card.rotate_card(randf_range(0.0, 360.0))
	spawned_cards.append(new_card)

func _on_card_spawn_delay_timeout() -> void:
	if spawned_cards.size() < GlobalNode.gene_cards_drawn:
		_spawn_new_card()
	else:
		card_spawn_delay.stop()

func _on_new_snap_position(pos : Vector2, is_top : bool) -> void:
	GlobalNode.held_card.snap_to(pos)
	GlobalNode.held_card.flip_card(is_top)
