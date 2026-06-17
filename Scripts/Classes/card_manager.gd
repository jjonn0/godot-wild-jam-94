class_name CardManager extends Node

@export var card_directory_path : StringName

var a_type_cards : Array[PackedScene] = []
var c_type_cards : Array[PackedScene] = []
var g_type_cards : Array[PackedScene] = []
var t_type_cards : Array[PackedScene] = []

func _ready() -> void:
	GlobalNode.card_manager = self
	_load_cards_from_file()

func _load_cards_from_file() -> void:
	var master_dir : DirAccess = DirAccess.open(card_directory_path)
	for dir in master_dir.get_directories():
		var card_dir : DirAccess = DirAccess.open("%s/%s" % [card_directory_path, dir])
		for card in card_dir.get_files():
			var card_path : String = "%s/%s/%s" % [card_directory_path, dir, card]
			match dir:
				"A":
					a_type_cards.append(load(card_path))
				"C":
					c_type_cards.append(load(card_path))
				"G":
					g_type_cards.append(load(card_path))
				"T":
					t_type_cards.append(load(card_path))

func get_cards() -> Array[GeneCard]:
	var return_array : Array[GeneCard] = []
	while return_array.size() < GlobalNode.cards_drawn:
		var empty_array_count : int = 0
		for card_array : Array[PackedScene] in [a_type_cards, c_type_cards, g_type_cards, t_type_cards]:
			if card_array.size() == 0:
				empty_array_count += 1
				if empty_array_count == 4:
					push_error("[%s]: Could not find cards." % self)
					return []
				continue
			var r : int = randi() % card_array.size()
			var card : GeneCard = card_array[r].instantiate()
			return_array.append(card)
			if return_array.size() == GlobalNode.cards_drawn:
				break
	return return_array
