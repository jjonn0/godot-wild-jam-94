class_name DNAStrand extends Node2D

signal new_snap_marker(pos : Vector2, is_top : bool)

const NUCLEOTIDE_BACKING = preload("uid://b5nrjb0o3i6ni")
const SLIDE_EASE_VALUE : float = -2.0
const SLIDE_EASE_STEPS : int = 60

var nucleotide_pairings : Array[NucleotideBacking] = []

# Strand spawning vars
var _start_position : Vector2
var _leftmost_position : Vector2
# Nucleotide line hint vars
var _origin_position : Vector2
var _target_position : Vector2

var _slide_ease_step : int = 0

func _ready() -> void:
	_start_position = global_position
	_create_dna_strand()

func _physics_process(_delta: float) -> void:
	if _slide_ease_step < SLIDE_EASE_STEPS:
		global_position.x = (_start_position.x - _leftmost_position.x) * ease(float(_slide_ease_step) / float(SLIDE_EASE_STEPS), SLIDE_EASE_VALUE)
		_slide_ease_step += 1
	if GlobalNode.is_card_picked_up:
		calculate_closest_free_connection(get_global_mouse_position())
	queue_redraw()

func _draw() -> void:
	if GlobalNode.is_card_picked_up:
		draw_line(_origin_position - global_position, _target_position - global_position, Color(0.914, 0.0, 0.291, 1.0), 2.0)

func _create_dna_strand() -> void:
	for slot_pairs in range(GlobalNode.max_pairs_in_strand):
		var new_pair : NucleotideBacking = NUCLEOTIDE_BACKING.instantiate()
		if nucleotide_pairings.size() == 0:
			new_pair.global_position = global_position - new_pair.right_point.global_position
		else:
			new_pair.global_position = nucleotide_pairings.back().left_point.global_position - new_pair.right_point.global_position - global_position
		add_child(new_pair)
		nucleotide_pairings.append(new_pair)
	_leftmost_position = nucleotide_pairings.back().left_point.global_position

func calculate_closest_free_connection(pos : Vector2) -> void:
	var sites : Array[DNASnapMarker] = []
	var is_top : bool = false
	for pairing in nucleotide_pairings:
		sites.append_array([pairing.top_point, pairing.bottom_point])
	var distance : float = sites[0].global_position.distance_to(pos)
	for site in sites:
		if site.global_position.distance_to(pos) <= distance:
			distance = site.global_position.distance_to(pos)
			_target_position = site.global_position
			is_top = site.is_top
	_origin_position = pos
	new_snap_marker.emit(_target_position, is_top)
