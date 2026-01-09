extends Node

signal player_changed

const PLAYER = preload("res://Player/player.tscn")

var player : Player
var players_spawned : bool = false
var players : Array[Player]
var player_count : int = 0

func _ready() -> void:
	if not player_changed.is_connected(_on_player_change):
		player_changed.connect(_on_player_change)

func add_player_instances() -> void:
	player_count = get_tree().get_first_node_in_group("levels").find_children("*", "PlayerSpawn").size()
	
	if player_count == 0:
		for n in get_tree().get_nodes_in_group("levels"):
			if n is Level:
				for c in n.get_children():
					if c is PlayerSpawn:
						player_count += 1
	
	for i in player_count:
		player = PLAYER.instantiate()
		add_child(player)
		players.append(player)

func set_player_position(_p : Player, _new_pos : Vector2) -> void:
	_p.global_position = _new_pos

func set_players_as_parent(_p : Node2D) -> void:
	
	for p in players:
		if p.get_parent() != null:
			p.get_parent().remove_child(p)
		else:
			add_player_instances()
			p.get_parent().remove_child(p)
		_p.add_child(p)

func unparent_players(_p : Node2D) -> void:
	for p in players:
		_p.remove_child(p)

func _on_player_change() -> void:
	pass
