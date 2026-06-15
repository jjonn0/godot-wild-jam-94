@tool
class_name GeneCard extends Node2D

const A_CARD_TEXTURE = preload("uid://dam60otaj483u")
const C_CARD_TEXTURE = preload("uid://dis0vc2l4vji1")
const G_CARD_TEXTURE = preload("uid://dodh3fsp3u4ej")
const T_CARD_TEXTURE = preload("uid://cr647g6b8vnex")

const A_CARD_COLOR : Color = Color(0.743, 0.608, 0.99, 1.0)
const C_CARD_COLOR : Color = Color(0.604, 0.99, 0.649, 1.0)
const G_CARD_COLOR : Color = Color(0.99, 0.829, 0.604, 1.0)
const T_CARD_COLOR : Color = Color(0.604, 0.791, 0.99, 1.0)

const HELD_Z_LAYER : int = 2
const UNHELD_Z_LAYER : int = 1

# For easing graphs: https://raw.githubusercontent.com/godotengine/godot-docs/master/img/ease_cheatsheet.png
const _FLIP_EASE_VALUE : float = -3.0
const _FLIP_STEPS : int = 30
const _SLIDE_EASE_VALUE : float = 0.2
const _SLIDE_STEPS : int = 80
const _SNAP_EASE_VALUE : float = 5.0
const _SNAP_STEPS : int = 80

enum CardType{A, T, C, G}

@onready var card_sprite: Sprite2D = $CardBacking
@onready var icon_sprite: Sprite2D = $CardBacking/Icon
@onready var bottom_point: Marker2D = $CardBacking/BottomPoint

@export_category("Card Properties")
@export var card_name : String
@export var card_description : String
@export var card_type : CardType:
	set(value):
		card_type = value
		if card_sprite != null:
			_update_sprite()
@export var card_icon : CompressedTexture2D:
	set(value):
		card_icon = value
		if icon_sprite != null:
			_update_sprite()
@export_group("Technical")
@export var upside_down : bool = false:
	set(value):
		upside_down = value
		_flip_animation_step = 0

var is_mouse_inside : bool = false

# Animation variables
## What step the flipping animation is currently at.
var _flip_animation_step : int = 0
## Whether or not the card should slide to a target position.
var _slide_to_spawn : bool = false
## Whether or not the card has reached its targeted spawn position.
var _is_at_spawn : bool = false
## The step in the sliding animation.
var _spawn_animation_step : int = 0
## The target spawn position for the card to move to.
var _slide_target : Vector2
## The initial spawn point for the card.
var _initial_spawn : Vector2
## If the card is currently held.
var _is_held : bool = false
var _snap_animation_step : int = _SNAP_STEPS
var _start_snap_target : Vector2
var _end_snap_target : Vector2
var _is_in_dna : bool = false

func _ready() -> void:
	_update_sprite()

func _input(_event: InputEvent) -> void:
	match [is_mouse_inside, Input.is_action_pressed("primary_interaction"), GlobalNode.is_card_picked_up, _is_held]:
		[true, true, false, false]:
			_is_held = true
			GlobalNode.is_card_picked_up = true
			z_index = HELD_Z_LAYER
			GlobalNode.held_card = self
		[_, false, true, true]:
			_is_held = false
			GlobalNode.is_card_picked_up = false
			z_index = UNHELD_Z_LAYER
			GlobalNode.held_card = null

func _process(_delta: float) -> void:
	icon_sprite.rotation_degrees = -card_sprite.rotation_degrees
	#region Flipping Logic
	if _is_held:
		if upside_down and card_sprite.rotation_degrees != 180.0:
			card_sprite.rotation_degrees = 180.0 * ease(float(_flip_animation_step) / float(_FLIP_STEPS), _FLIP_EASE_VALUE)
		elif not upside_down and card_sprite.rotation_degrees != 360.0:
			card_sprite.rotation_degrees = 180.0 * ease(float(_flip_animation_step) / float(_FLIP_STEPS), _FLIP_EASE_VALUE) + 180.0
	if _flip_animation_step < _FLIP_STEPS:
		_flip_animation_step += 1
	#endregion
	#region Card Spawn Sliding Logic
	if _slide_to_spawn and not _is_at_spawn:
		var slide_progression : float = ease(float(_spawn_animation_step) / float(_SLIDE_STEPS), _SLIDE_EASE_VALUE)
		global_position = slide_progression * (_slide_target - _initial_spawn) + _initial_spawn
		if _spawn_animation_step < _SLIDE_STEPS:
			_spawn_animation_step += 1
		else:
			_is_at_spawn = true
	#endregion
	#region Card Snapping Logic
	if _snap_animation_step <= _SNAP_STEPS and not _is_held and not Engine.is_editor_hint():
		var snap_progression : float = ease(float(_snap_animation_step) / float(_SNAP_STEPS), _SNAP_EASE_VALUE)
		global_position = snap_progression * (_end_snap_target - _start_snap_target) + _start_snap_target + global_position - bottom_point.global_position
		_snap_animation_step += 1
	#endregion
	if _is_held:
		global_position = get_global_mouse_position()

func _update_sprite() -> void:
	match card_type:
		CardType.A:
			card_sprite.texture = A_CARD_TEXTURE
			self.modulate = A_CARD_COLOR
		CardType.T:
			card_sprite.texture = T_CARD_TEXTURE
			self.modulate = T_CARD_COLOR
		CardType.C:
			card_sprite.texture = C_CARD_TEXTURE
			self.modulate = C_CARD_COLOR
		CardType.G:
			card_sprite.texture = G_CARD_TEXTURE
			self.modulate = G_CARD_COLOR
	icon_sprite.texture = card_icon

func rotate_card(new_rotation : float) -> void:
	card_sprite.rotation_degrees = new_rotation

func flip_card(_upside_down : bool) -> void:
	if upside_down != _upside_down:
		_flip_animation_step = 0
		upside_down = _upside_down

func spawn_and_move(from : Vector2, to : Vector2) -> void:
	_slide_to_spawn = true
	_is_at_spawn = false
	_slide_target = to
	_initial_spawn = from

func snap_to(new_position : Vector2) -> void:
	_start_snap_target = global_position
	_end_snap_target = new_position
	_is_in_dna = false
	_snap_animation_step = 0

## What the card does before activation. Use for effects.
func pre_activation() -> void:
	# Pre-activation code
	activate()

## What the card does when activated. Use for stat/creature modification ONLY.
func activate() -> void:
	pass

func _on_hitbox_mouse_entered() -> void:
	is_mouse_inside = true

func _on_hitbox_mouse_exited() -> void:
	is_mouse_inside = false
