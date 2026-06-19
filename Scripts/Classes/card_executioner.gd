class_name CardExecutioner extends Node

var scripts : Array[CardScript] = []
var execution_order : Array[CardScript] = []
var _exe_index : int = 0

func set_execution_list(new_scripts : Array[CardScript]) -> void:
	scripts = new_scripts
	for script in scripts:
		if script:
			execution_order.append(script)
			var signal_function_dictionary : Dictionary[Signal, Callable] = {
				script.on_run_right_card_script : _on_run_right_card_script,
				script.on_disable_one_random_card : _on_disable_one_random_card
			}
			for key : Signal in signal_function_dictionary:
				key.connect(signal_function_dictionary[key])

func run_scripts() -> void:
	while _exe_index < execution_order.size():
		var card_script : CardScript = execution_order[_exe_index]
		if card_script != null:
			if not card_script.disabled:
				card_script.on_activation()
		_exe_index += 1

func get_result() -> Array[CardScript]:
	return execution_order

func _on_run_right_card_script(calling_script : CardScript) -> void:
	var script_index : int = scripts.find(calling_script)
	if script_index == -1:
		push_error("[%s]: Card script (%s) was not found in the following list: %s." % [self, calling_script, scripts])
		return
	if script_index % GlobalNode.dna_strand_pairs == (scripts.size() - 1) % GlobalNode.dna_strand_pairs:
		return
	
	execution_order.insert(_exe_index + 1, scripts[script_index + 1])

func _on_disable_one_random_card(calling_script : CardScript) -> void:
	var script_index : int = scripts.find(calling_script)
	
	if script_index == -1:
		push_error("[%s]: Card script (%s) was not found in the following list: %s." % [self, calling_script, scripts])
		return
	
	var random_index : int = 0
	while true:
		random_index = randi_range(0, scripts.size() - 1)
		if random_index != script_index:
			break
	scripts[random_index].on_card_disable.emit(true)
