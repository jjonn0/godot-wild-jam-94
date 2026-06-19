class_name Creature extends Node2D

signal attack(damage : float)
signal on_death(calling_node : Creature)

@export var creature_sprite : ColorRect
@export var attacked_sprite : AnimatedSprite2D
@export var slide_target : Marker2D
@export var state_machine : StateMachine

var player_owned : bool = true
var creature_data : CreatureData

var return_position : Vector2
var slide_position : Vector2

func _init(new_creature_data : CreatureData = CreatureData.new()) -> void:
	creature_data = new_creature_data

func reset() -> void:
	return_position = global_position
	if not player_owned:
		slide_position = Vector2(global_position.x - slide_target.position.x, slide_target.global_position.y)
	else:
		slide_position = slide_target.global_position

func take_damage(amount : float) -> void:
	creature_data.current_health -= amount
	attacked_sprite.play()
	if creature_data.current_health <= 0.0:
		print("[%s]: Just died!" % self)
		on_death.emit(self)
