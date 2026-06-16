extends PanelContainer

@export var card_type_label : Label
@export var card_title_label : Label
@export var card_desc_label : Label

@export var mutation_seperator : HSeparator
@export var mutation_title_label : Label
@export var mutation_desc_label : Label

func _ready() -> void:
	show_mutation(false)

func set_information(card_type : GlobalNode.CARD_TYPE, card_title : String, card_desc : String) -> void:
	match card_type:
		GlobalNode.CARD_TYPE.A:
			card_type_label.add_theme_color_override("font_color", GlobalNode.A_CARD_COLOR)
			card_type_label.text = "A"
		GlobalNode.CARD_TYPE.C:
			card_type_label.add_theme_color_override("font_color", GlobalNode.C_CARD_COLOR)
			card_type_label.text = "C"
		GlobalNode.CARD_TYPE.G:
			card_type_label.add_theme_color_override("font_color", GlobalNode.G_CARD_COLOR)
			card_type_label.text = "G"
		GlobalNode.CARD_TYPE.T:
			card_type_label.add_theme_color_override("font_color", GlobalNode.T_CARD_COLOR)
			card_type_label.text = "T"
	card_title_label.text = card_title
	card_desc_label.text = card_desc

func show_mutation(is_mutated : bool) -> void:
	if is_mutated:
		mutation_seperator.show()
		mutation_title_label.show()
		mutation_desc_label.show()
	else:
		mutation_seperator.hide()
		mutation_title_label.hide()
		mutation_desc_label.hide()
