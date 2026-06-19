@abstract
class_name State extends Node

signal _state_transition(new_state : State, calling_state : State)
var state_machine : StateMachine

@abstract
func start() -> void

@abstract
func process(delta : float) -> void

@abstract
func physics(delta : float) -> void

@abstract
func end() -> void
