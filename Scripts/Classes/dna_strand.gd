class_name DNAStrand extends Node2D

const NUCLEOTIDE_BACKING = preload("uid://b5nrjb0o3i6ni")
const SLIDE_WEIGHT : float = 15.0

var nucleotide_pair_refs : Array[NucleotideBacking] = []
var left_point : Marker2D
var right_point : Marker2D

func _ready() -> void:
	_generate_dna_strand()

func _generate_dna_strand() -> void:
	var last_pair : NucleotideBacking = null
	for nucleotide_pair in GlobalNode.dna_strand_pairs:
		var pair : NucleotideBacking = NUCLEOTIDE_BACKING.instantiate()
		if last_pair == null:
			pair.global_position = global_position - pair.right_point.global_position
		else:
			pair.global_position = last_pair.right_point.global_position + pair.right_point.global_position
		last_pair = pair
		add_child(pair)
		nucleotide_pair_refs.append(pair)
	left_point = nucleotide_pair_refs.front().left_point
	right_point = nucleotide_pair_refs.back().right_point

func get_closest_free_site(gene_card : GeneCard) -> DNASnapMarker:
	var pos : Vector2 = gene_card.global_position
	var free_sites : Array[DNASnapMarker] = []
	for pairing in nucleotide_pair_refs:
		for site : DNASnapMarker in [pairing.top_point, pairing.bottom_point]:
			if site.held_card == null and site.current_accepted_types.has(gene_card.card_type):
				free_sites.append(site)
	if free_sites.size() == 0:
		return null
	var closest_site : DNASnapMarker = free_sites[0]
	var closest_dist : float = free_sites[0].global_position.distance_to(pos)
	for site in free_sites:
		if site.global_position.distance_to(pos) <= closest_dist:
			closest_site = site
			closest_dist = site.global_position.distance_to(pos)
	return closest_site
