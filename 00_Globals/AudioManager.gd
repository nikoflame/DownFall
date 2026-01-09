extends Node

@onready var jump: AudioStreamPlayer2D = $Jump
@onready var jump_2: AudioStreamPlayer2D = $jump2
@onready var ding: AudioStreamPlayer2D = $ding
@onready var box_break_1: AudioStreamPlayer2D = $box_break1
@onready var box_break_2: AudioStreamPlayer2D = $box_break2
@onready var goal: AudioStreamPlayer2D = $goal
@onready var bomb_timer: AudioStreamPlayer2D = $bomb_timer

@onready var music_start: AudioStreamPlayer2D = $music_start
@onready var music_creator: AudioStreamPlayer2D = $music_creator
@onready var music_levels_1: AudioStreamPlayer2D = $music_levels_1
@onready var music_levels_2: AudioStreamPlayer2D = $music_levels_2
@onready var music_levels_3: AudioStreamPlayer2D = $music_levels_3
@onready var music_levels_4: AudioStreamPlayer2D = $music_levels_4

var level_music : Array[AudioStreamPlayer2D]

func _ready() -> void:
	if not SaveManager.game_loaded:
		await SaveManager.game_load_done
	
	for m in get_tree().get_nodes_in_group("music"):
		if not m.finished.is_connected(check_scene_and_play):
			m.finished.connect(check_scene_and_play)
	
	level_music = [
		music_levels_1,
		music_levels_2,
		music_levels_3,
		music_levels_4
	]
	
	music_start.play()

func play_level_music() -> void:
	if (
		not music_levels_1.playing
		and not music_levels_2.playing
		and not music_levels_3.playing
		and not music_levels_4.playing
		):
		music_start.stop()
		randomize_and_play()
		music_creator.stop()

func play_start_music() -> void:
	if not music_start.playing:
		music_start.play()
		stop_levels()
		music_creator.stop()

func play_creator_music() -> void:
	if not music_creator.playing:
		music_start.stop()
		stop_levels()
		music_creator.play()

func check_scene_and_play() -> void:
	if StartMenu.visible:
		play_start_music()
	elif StartMenu.level_creator_active:
		play_creator_music()
	else:
		play_level_music()

func randomize_and_play() -> void:
	if level_music.size() == 0:
		level_music = [
		music_levels_1,
		music_levels_2,
		music_levels_3,
		music_levels_4
	]
	var random := randi_range(0, level_music.size() - 1)
	level_music[random].play()
	level_music.remove_at(random)

func stop_levels() -> void:
	music_levels_1.stop()
	music_levels_2.stop()
	music_levels_3.stop()
	music_levels_4.stop()
