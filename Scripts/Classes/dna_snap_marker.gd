class_name DNASnapMarker extends Marker2D

signal held_card_updated(held_card : GeneCard)

@export var is_top : bool
var held_card : GeneCard = null:
	set(value):
		if value == null:
			if GlobalNode.dna_cards.has(held_card):
				GlobalNode.dna_cards.erase(held_card)
		else:
			GlobalNode.dna_cards.append(value)
		held_card = value
		held_card_updated.emit(value)
var current_accepted_types : Array[GlobalNode.CARD_TYPE] = [GlobalNode.CARD_TYPE.A, GlobalNode.CARD_TYPE.C, GlobalNode.CARD_TYPE.G, GlobalNode.CARD_TYPE.T]

func reset_accepted_types() -> void:
	if held_card == null:
		current_accepted_types = [GlobalNode.CARD_TYPE.A, GlobalNode.CARD_TYPE.C, GlobalNode.CARD_TYPE.G, GlobalNode.CARD_TYPE.T]
