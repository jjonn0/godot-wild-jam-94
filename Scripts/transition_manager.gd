class_name TransitionManager extends Node

const GENE_EDITOR = preload("uid://ckumx0euj54hi")
const FIGHT_SCENE = preload("uid://cc5lckj6ohdwe")
const FIGHT_HUD = preload("uid://c3bu5pkrdq3gm")

@export var gui_root : Control
@export var world_2d_root : Node2D
@export var transition_layer : TransitionLayer
@export var starting_gui : PackedScene
@export var starting_world_2d : PackedScene

var current_gui_scene : Control
var current_world_2d_scene : Node2D

func _ready() -> void:
	GlobalNode.transition_manager = self
	transition_to_gene_editor()

func switch_gui_scene(new_scene : PackedScene, delete : bool) -> void:
	if current_gui_scene:
		if delete:
			current_gui_scene.queue_free()
		else:
			gui_root.remove_child(current_gui_scene)
	if new_scene:
		current_gui_scene = new_scene.instantiate()
		gui_root.add_child(current_gui_scene)

func switch_gui_scene_with_node(node : Control, delete : bool) -> void:
	if current_gui_scene:
		if delete:
			current_gui_scene.queue_free()
		else:
			gui_root.remove_child(current_gui_scene)
	if node:
		current_gui_scene = node
		gui_root.add_child(current_gui_scene)

func switch_world_2d_scene(new_scene : PackedScene, delete : bool) -> void:
	if current_world_2d_scene:
		if delete:
			current_world_2d_scene.queue_free()
		else:
			world_2d_root.remove_child(current_world_2d_scene)
	if new_scene:
		current_world_2d_scene = new_scene.instantiate()
		world_2d_root.add_child(current_world_2d_scene)

func transition_to_gene_editor() -> void:
	if not transition_layer.screen_covered.is_connected(_on_transition_to_gene_editor):
		transition_layer.screen_covered.connect(_on_transition_to_gene_editor)
	transition_layer.static_overlay_cover(1.0, 10)

func _on_transition_to_gene_editor() -> void:
	if not GlobalNode.gene_editor:
		switch_gui_scene(GENE_EDITOR, true)
	else:
		switch_gui_scene_with_node(GlobalNode.gene_editor, true)
	switch_world_2d_scene(null, true)
	transition_layer.static_overlay_clear(1.0, 10)
	transition_layer.screen_covered.disconnect(_on_transition_to_gene_editor)

func transition_to_fight_scene() -> void:
	if not transition_layer.screen_covered.is_connected(_on_transition_to_fight_scene):
		transition_layer.screen_covered.connect(_on_transition_to_fight_scene)
	transition_layer.static_overlay_cover(1.0, 10)

func _on_transition_to_fight_scene() -> void:
	switch_world_2d_scene(FIGHT_SCENE, true)
	switch_gui_scene(FIGHT_HUD, false)
	transition_layer.static_overlay_clear(1.0, 10)
	transition_layer.screen_covered.disconnect(_on_transition_to_fight_scene)
