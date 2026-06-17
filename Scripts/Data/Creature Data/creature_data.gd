class_name CreatureData extends Resource

## The maximum health points a creature can start off with.
@export var start_health : float = 0.0
## The lowest and highest damage a creature can roll (respectively).
@export var damage_range : Vector2 = Vector2.ZERO
## The number of seconds it takes before the creature can attack again.
@export var attack_speed : float = 1.0

var current_health : float
var current_damage_range : Vector2
var current_attack_speed : float

func reset() -> void:
	current_health = start_health
	current_damage_range = damage_range
	current_attack_speed = attack_speed

func temporarily_modify(modifiers : Dictionary[String, Variant]) -> void:
	for key in modifiers:
		var val : Variant = modifiers[key]
		match [key, typeof(val)]:
			["health_mult", 3]:
				current_health *= val
			["health_add", 3]:
				current_health += val
			["attack_mult", 3]:
				damage_range *= val
			["attack_add", 3]:
				damage_range.x += val
				damage_range.y += val
			["speed_mult", 3]:
				current_attack_speed *= val
			["speed_add", 3]:
				current_attack_speed += val
			_:
				push_error("[%s]: Modifier value (%s) is not accepted for type \"%s\"" % [self, val, key])
	print(current_health)
