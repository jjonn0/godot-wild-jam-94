extends Control

const CARD_FOLLOW_SPEED : float = 50.0
const DNA_ARROW = preload("uid://dle3cxu2w2cy1")

@export_category("Technical")
@export var card_start_box : ReferenceRect
@export var card_end_box : ReferenceRect
@export var dna_spawn_point : Marker2D
@export var max_snapping_distance : float = 50.0
@export var start_button : Button

var _snapped_cards : Array[GeneCard] = []
## An array containing every unsnapped gene card. Used for moving cards back to the right place.
var _unsnapped_cards : Array[GeneCard] = []

# Card holding/snapping
var _held_card : GeneCard
var _dna_strand_ref : DNAStrand
var _closest_site_ref : DNASnapMarker
var _can_snap_card : bool = false

# Checks
var _strand_full : bool = false
var _awaiting_transition : bool = false

func _ready() -> void:
	GlobalNode.game_data.reset_stats()
	spawn_cards()
	_dna_strand_ref = DNAStrand.new()
	add_child(_dna_strand_ref)
	_dna_strand_ref.global_position = dna_spawn_point.global_position - _dna_strand_ref.left_point.global_position
	GlobalNode.music_manager.play_gene_editor_music()
	_strand_full = check_if_strand_is_full()
	start_button.disabled = !_strand_full

func _draw() -> void:
	if _closest_site_ref and _can_snap_card and _held_card:
		draw_line(_closest_site_ref.global_position, get_global_mouse_position(), Color(0.0, 1.0, 0.217, 1.0), 2.0)

func _process(delta: float) -> void:
	if _awaiting_transition:
		return
	if _held_card:
		_held_card.global_position = _held_card.global_position.lerp(get_global_mouse_position(), delta * CARD_FOLLOW_SPEED)
		_closest_site_ref = _dna_strand_ref.get_closest_free_site(_held_card)
		if _closest_site_ref != null:
			if _closest_site_ref.global_position.distance_to(get_global_mouse_position()) <= max_snapping_distance:
				_held_card.flip_upside_down(_closest_site_ref.is_top)
				_can_snap_card = true
				
				queue_redraw()
			else:
				_can_snap_card = false
				_held_card.flip_upside_down(false)
				queue_redraw()
	for card in _unsnapped_cards:
		var rect : Rect2 = card_end_box.get_rect()
		card.global_position = Vector2(clampf(card.global_position.x, rect.position.x, rect.end.x), clampf(card.global_position.y, rect.position.y, rect.end.y))

func _on_card_clicked(gene_card : GeneCard) -> void:
	if _awaiting_transition:
		return
	if _held_card:
		return
	_held_card = gene_card
	
	for pairing in _dna_strand_ref.nucleotide_pair_refs:
		for site : DNASnapMarker in [pairing.top_point, pairing.bottom_point]:
			if site.held_card == gene_card:
				site.held_card = null
	if _unsnapped_cards.has(gene_card):
		_unsnapped_cards.erase(gene_card)
		_snapped_cards.append(gene_card)

func _on_card_released(gene_card : GeneCard) -> void:
	if _awaiting_transition:
		return
	if gene_card != _held_card:
		return
	_held_card = null
	if _can_snap_card and _closest_site_ref != null:
		_closest_site_ref.held_card = gene_card
		gene_card.flip_upside_down(_closest_site_ref.is_top)
		gene_card.snap_to_position(_closest_site_ref.global_position)
		if _unsnapped_cards.has(gene_card):
			_unsnapped_cards.erase(gene_card)
	else:
		gene_card.global_position = get_global_mouse_position()
		if _snapped_cards.has(gene_card):
			_snapped_cards.erase(gene_card)
			_unsnapped_cards.append(gene_card)
	_strand_full = check_if_strand_is_full()
	start_button.disabled = !_strand_full

func spawn_cards() -> void:
	var card_array : Array[GeneCard] = GlobalNode.card_manager.get_cards()
	for card in card_array:
		card.card_clicked.connect(_on_card_clicked)
		card.card_released.connect(_on_card_released)
		card.global_position = get_rand_pos_in_rect(card_end_box)
		add_child(card)
		_unsnapped_cards.append(card)

func get_rand_pos_in_rect(reference_rect : ReferenceRect) -> Vector2:
	var return_vector : Vector2
	var rect : Rect2 = reference_rect.get_rect()
	return_vector.x = randf_range(rect.position.x, rect.end.x)
	return_vector.y = randf_range(rect.position.y, rect.end.y)
	return return_vector

func check_if_strand_is_full() -> bool:
	if _snapped_cards.size() == GlobalNode.dna_strand_pairs * 2:
		return true
	return false

func _on_start_button_pressed() -> void:
	_awaiting_transition = true
	var new_executioner : CardExecutioner = CardExecutioner.new()
	var execution_list : Array[CardScript] = []
	add_child(new_executioner)
	for pair : NucleotideBacking in _dna_strand_ref.nucleotide_pair_refs:
		execution_list.append(pair.top_point.held_card.card_script)
	for pair : NucleotideBacking in _dna_strand_ref.nucleotide_pair_refs:
		execution_list.append(pair.bottom_point.held_card.card_script)
	new_executioner.set_execution_list(execution_list)
	new_executioner.run_scripts()
	
	var result : Array[CardScript] = new_executioner.get_result()
	var cards : Array[GeneCard] = []
	for script in result:
		for card in _snapped_cards:
			if card.card_script == script:
				cards.append(card)
	var dna_arrow : Sprite2D = DNA_ARROW.instantiate()
	dna_arrow.cards = cards
	add_child(dna_arrow)
	dna_arrow.start_animation()
