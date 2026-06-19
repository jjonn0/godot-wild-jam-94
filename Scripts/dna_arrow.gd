extends Sprite2D

const FIGHT_SCENE = preload("uid://cc5lckj6ohdwe")

@onready var animation_timer: Timer = $AnimationTimer

@export var animation_start_time : float = 0.7
@export var animation_time_factor : float = 0.95
var current_animation_time : float

var _next_card : GeneCard
var index : int

func _ready() -> void:
	current_animation_time = animation_start_time
	index = 0

func _process(delta: float) -> void:
	if not _next_card:
		return
	var animation_weight : float = clampf(delta / pow(current_animation_time, 2.0), 0.2, 0.7)
	if global_position != _next_card.bottom_point.global_position:
		global_position = global_position.lerp(_next_card.bottom_point.global_position, animation_weight)
	if _next_card._upside_down:
		rotation_degrees = lerp(rotation_degrees, 0.0, animation_weight)
	else:
		rotation_degrees = lerp(rotation_degrees, 180.0, animation_weight)

func update_next_card(gene_card_ref : GeneCard) -> void:
	_next_card = gene_card_ref
	_next_card.bounce_card(Vector2.ONE * _next_card.HOVER_SIZE, 10.0)
	animation_timer.start(current_animation_time)
	current_animation_time = clampf(current_animation_time * animation_time_factor, 0.2, 1.0)
