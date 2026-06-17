class_name MusicManager extends AudioStreamPlayer

const DEFAULT_BUS_LAYOUT = preload("uid://dnhr3i3jnq8pu")

const WHAT_MAKES_LIFE_TICK = preload("uid://dii65spodd0ek")
const MELANCHOLIC_CURIOSITY = preload("uid://phngs15r7y01")

var gene_editor_playlist : Array[AudioStreamWAV] = [WHAT_MAKES_LIFE_TICK, MELANCHOLIC_CURIOSITY]

var current_playlist : Array[AudioStreamWAV] = []
var song_index : int = 0

func _ready() -> void:
	GlobalNode.music_manager = self
	finished.connect(_on_finished)

func _switch_track(playlist : Array[AudioStreamWAV]) -> void:
	stop()
	current_playlist = playlist
	song_index = 0
	stream = playlist[0]
	play()

func play_gene_editor_music() -> void:
	_switch_track(gene_editor_playlist)

func _on_finished() -> void:
	song_index += 1
	if song_index >= gene_editor_playlist.size():
		song_index = 0
	stream = current_playlist[song_index]
	play()
