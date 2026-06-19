extends VBoxContainer
@onready var health_label: Label = $HealthStats/HealthLabel
@onready var attack_range_label: Label = $HBoxContainer2/AttackRangeLabel
@onready var attack_speed_label: Label = $HBoxContainer3/AttackSpeedLabel
@onready var health_value: Label = $HealthStats/HealthValue
@onready var attack_range_values: Label = $HBoxContainer2/AttackRangeValues
@onready var attack_speed_value: Label = $HBoxContainer3/AttackSpeedValue

func _ready() -> void:
	health_label.text = "%-14s" % "Max Health:"
	attack_range_label.text = "%-14s" % "Attack Range:"
	attack_speed_label.text = "%-14s" % "Attack Speed:"

func update_stats(creature_data : CreatureData) -> void:
	health_value.text = "%13.3f" % creature_data.start_health
	attack_range_values.text = "%6.3f-%6.3f" % [creature_data.current_damage_range.x, creature_data.current_damage_range.y]
	attack_speed_value.text = "%13.3f" % creature_data.current_attack_speed
