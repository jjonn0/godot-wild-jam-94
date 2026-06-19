@tool
class_name GeneCard extends Node2D

signal card_clicked(gene_card : GeneCard)
signal card_released(gene_card : GeneCard)

const A_CARD = preload("uid://dam60otaj483u")
const C_CARD = preload("uid://dis0vc2l4vji1")
const G_CARD = preload("uid://dodh3fsp3u4ej")
const T_CARD = preload("uid://cr647g6b8vnex")

const HOVER_SIZE : float = 1.05

@onready var card_sprite: Sprite2D = $CardBacking
@onready var icon_sprite: Sprite2D = $CardBacking/Icon
@onready var bottom_point: Marker2D = $CardBacking/BottomPoint
@onready var info_box: PanelContainer = $InfoBox
@onready var hitbox: ReferenceRect = $Hitbox
@export var card_script : CardScript

@export var card_type : GlobalNode.CARD_TYPE:
	set(value):
		card_type = value
		_update_card_sprite()
@export var icon : CompressedTexture2D:
	set(value):
		icon = value
		if icon_sprite != null:
			icon_sprite.texture = value
@export var card_title : String = "N/A"
@export var card_desc : String = "N/A"

var disabled : bool = false

## Whether or not the mouse is hovered over the card.
var _is_mouse_hovered : bool = false
## Whether or not the mouse is clicking.
var _is_mouse_clicked : bool = false
## Whether or not the card should be upside down.
@export var _upside_down : bool = false
## The scaling the card will lerp to.
var _target_scaling : Vector2 = scale
var _scale_speed : float = 1.0

#region Animation vars
const CARD_ROTATION_STEPS : int = 50
const CARD_EASE_FLOAT : float = -2.0
var card_rotation_step : int = CARD_ROTATION_STEPS
var is_rotating : bool = false
#endregion

func _ready() -> void:
	if not Engine.is_editor_hint():
		info_box.hide()
		info_box.set_information(card_type, card_title, card_desc)
		if card_script:
			card_script.on_card_disable.connect(disabled_state)

func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if _is_mouse_hovered:
			info_box.global_position.y = get_global_mouse_position().y
		if _is_mouse_hovered and Input.is_action_pressed("primary_interaction") and not _is_mouse_clicked:
			card_clicked.emit(self)
			_is_mouse_clicked = true
		if Input.is_action_just_released("primary_interaction") and _is_mouse_clicked:
			card_released.emit(self)
			_is_mouse_clicked = false
	var additional_rotation : float
	match _upside_down:
		true:
			additional_rotation = 0.0
		_:
			additional_rotation = 180.0
	card_sprite.rotation_degrees = ease(float(card_rotation_step) / float(CARD_ROTATION_STEPS), CARD_EASE_FLOAT) * 180.0 - additional_rotation
	icon_sprite.rotation_degrees = -card_sprite.rotation_degrees
	if card_rotation_step < CARD_ROTATION_STEPS:
		card_rotation_step += 1
	if scale != _target_scaling:
		scale = scale.lerp(_target_scaling, delta * _scale_speed)

func _on_hitbox_mouse_entered() -> void:
	_is_mouse_hovered = true
	top_level = true
	scale_card(Vector2.ONE * HOVER_SIZE, 50.0)
	info_box.show()

func _on_hitbox_mouse_exited() -> void:
	_is_mouse_hovered = false
	top_level = false
	scale_card(Vector2.ONE, 50.0)
	info_box.hide()

func _update_card_sprite() -> void:
	if card_sprite != null:
		if disabled:
			card_sprite.modulate = Color(0.5, 0.5, 0.5, 1.0)
		else:
			match card_type:
				GlobalNode.CARD_TYPE.A:
					card_sprite.modulate = GlobalNode.A_CARD_COLOR
					card_sprite.texture = A_CARD
				GlobalNode.CARD_TYPE.C:
					card_sprite.modulate = GlobalNode.C_CARD_COLOR
					card_sprite.texture = C_CARD
				GlobalNode.CARD_TYPE.G:
					card_sprite.modulate = GlobalNode.G_CARD_COLOR
					card_sprite.texture = G_CARD
				_:
					card_sprite.modulate = GlobalNode.T_CARD_COLOR
					card_sprite.texture = T_CARD

func disabled_state(is_disabled : bool) -> void:
	print("test")
	disabled = is_disabled
	card_script.disabled = is_disabled
	_update_card_sprite()

func snap_to_position(pos : Vector2) -> void:
	if _upside_down:
		global_position = pos + bottom_point.position
	else:
		global_position = pos - bottom_point.position

func flip_upside_down(is_upside_down : bool) -> void:
	if _upside_down != is_upside_down:
		_upside_down = is_upside_down
		card_rotation_step = 0

func scale_card(target_scaling : Vector2, scaling_speed : float) -> void:
	_target_scaling = target_scaling
	_scale_speed = scaling_speed

func bounce_card(target_scaling : Vector2, scaling_speed : float) -> void:
	scale = target_scaling
	scale_card(Vector2.ONE, scaling_speed)
