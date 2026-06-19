extends Sprite2D

const FIGHT_SCENE = preload("uid://cc5lckj6ohdwe")

@onready var animation_timer: Timer = $AnimationTimer

@export var animation_start_time : float = 0.7
@export var animation_time_factor : float = 0.95
var current_animation_time : float

var cards : Array[GeneCard]
var index : int

func _ready() -> void:
	current_animation_time = animation_start_time
	index = 0

func _process(delta: float) -> void:
	if cards.size() == 0:
		return
	var animation_weight : float = clampf(delta / pow(current_animation_time, 2.0), 0.2, 0.7)
	if global_position != cards[index].bottom_point.global_position:
		global_position = global_position.lerp(cards[index].bottom_point.global_position, animation_weight)
	if cards[index]._upside_down:
		rotation_degrees = lerp(rotation_degrees, 0.0, animation_weight)
	else:
		rotation_degrees = lerp(rotation_degrees, 180.0, animation_weight)

func start_animation() -> void:
	if cards.size() == 0:
		return
	global_position = cards[index].bottom_point.global_position
	cards[index].bounce_card(Vector2.ONE * cards[index].HOVER_SIZE, 10.0)
	animation_timer.start(current_animation_time)

func _on_animation_timer_timeout() -> void:
	current_animation_time = clampf(current_animation_time * animation_time_factor, 0.2, 1.0)
	index += 1
	if index < cards.size():
		cards[index].bounce_card(Vector2.ONE * cards[index].HOVER_SIZE, 10.0)
		animation_timer.start(current_animation_time)
	else:
		index -= 1
		GlobalNode.transition_manager.transition_to_fight_scene()
