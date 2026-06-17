class_name NucleotideBacking extends Node2D

@export var right_point: Marker2D
@export var left_point: Marker2D
@export var bottom_point: DNASnapMarker
@export var top_point: DNASnapMarker

func _ready() -> void:
	top_point.held_card_updated.connect(_on_top_point_update)
	bottom_point.held_card_updated.connect(_on_bottom_point_update)

func _get_opposite(card_type : GlobalNode.CARD_TYPE) -> GlobalNode.CARD_TYPE:
	match card_type:
		GlobalNode.CARD_TYPE.A:
			return GlobalNode.CARD_TYPE.T
		GlobalNode.CARD_TYPE.C:
			return GlobalNode.CARD_TYPE.G
		GlobalNode.CARD_TYPE.G:
			return GlobalNode.CARD_TYPE.C
		_:
			return GlobalNode.CARD_TYPE.A

func _on_top_point_update(gene_card : GeneCard) -> void:
	if gene_card != null:
		bottom_point.current_accepted_types = [_get_opposite(gene_card.card_type)]
	else:
		if not bottom_point.held_card:
			top_point.reset_accepted_types()
		bottom_point.reset_accepted_types()

func _on_bottom_point_update(gene_card : GeneCard) -> void:
	if gene_card != null:
		top_point.current_accepted_types = [_get_opposite(gene_card.card_type)]
	else:
		if not top_point.held_card:
			bottom_point.reset_accepted_types()
		top_point.reset_accepted_types()

func get_accepted_types(snap_marker : DNASnapMarker) -> Array[GlobalNode.CARD_TYPE]:
	if snap_marker == top_point:
		return top_point.current_accepted_types
	elif snap_marker == bottom_point:
		return bottom_point.current_accepted_types
	return []
