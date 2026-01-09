class_name Level extends Node2D

@onready var tilemap: TileMapLayer = $Tilemap
@onready var goal : Goal

@onready var button: Button

const BREAKABLE_WALL = preload("uid://dqm8v3qt8ah42")
const BUTTON = preload("uid://b26njhvwluy2i")
const BUTTON_DOOR = preload("uid://c6j301y8f566b")
const GOAL = preload("uid://bnwirpv537d3o")
const CIRCLE = preload("uid://cp3kqrfqht8v6")
const MOON = preload("uid://b5roxb43svd8k")
const SQUARE = preload("uid://w6cdn4briwmh")
const TRIANGLE = preload("uid://rbc1geulex1e")

var level_loaded : bool = false
var is_custom_level : bool = false
var completed : bool = false

func _ready() -> void:
	if LevelManager.custom_level_mode:
		await LevelManager.data_loaded
	PlayerManager.set_players_as_parent(self)
	LevelManager.level_started = true
	await get_tree().process_frame
	tilemap = find_child("Tilemap")
	for n in get_tree().get_nodes_in_group("level_creator_objects"):
		if n is Goal:
			goal = n
			break
	await get_tree().create_timer(0.1).timeout
	level_loaded = true
	if StartMenu.test_mode:
		button = $Button
		button.visible = true
		if not button.pressed.is_connected(_on_button_pressed):
			button.pressed.connect(_on_button_pressed)

func _process(_delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	Selection.visible = false
	AudioManager.goal.pitch_scale = randf_range(0.95, 1.05)
	AudioManager.goal.play()
	await get_tree().create_timer(0.1).timeout
	LevelManager.return_to_level_creator()

func load_from_data(data: Dictionary) -> void:
	# Tiles
	for t in data.get("tiles", []):
		var coords := Vector2i(t["x"], t["y"])
		var atlas := Vector2i(t["atlas_x"], t["atlas_y"])
		var alt = t["alt"]
		var source_id = t["source_id"]
		tilemap.set_cell(coords, source_id, atlas, alt)
	
	# Objects
	var door_array : Array[ButtonDoor] = []
	for o in data.get("objects", []):
		var pos := Vector2(o["x"], o["y"])
		var node: Node2D = null
		
		match o["type"]:
			"BreakableWall":
				node = BREAKABLE_WALL.instantiate()
				node.size = o["size"]
				node.side = o["side"]
			"ButtonDoor":
				node = BUTTON_DOOR.instantiate()
				node.size = o["size"]
				node.side = o["side"]
				node.origin = o["origin"]
				node.opening_dir = o["opening_dir"]
				if o.has("button_x") and o.has("button_y"):
					node.button_x = o["button_x"]
					node.button_y = o["button_y"]
				door_array.append(node)
			"MyButton":
				node = BUTTON.instantiate()
				node.side = o["side"]
			"Goal":
				node = GOAL.instantiate()
			"PlayerSpawn":
				match o["_type"]:
					"Square":
						node = SQUARE.instantiate()
					"Triangle":
						node = TRIANGLE.instantiate()
					"Circle":
						node = CIRCLE.instantiate()
					"Moon":
						node = MOON.instantiate()
			_:
				continue
		
		node.global_position = pos
		add_child(node)
	
	# Connect buttons to doors
	for n in get_tree().get_nodes_in_group("level_creator_objects"):
		if n is MyButton:
			for d in door_array:
				if d.button_x and d.button_y:
					if d.button_x == n.global_position.x and d.button_y == n.global_position.y:
						d.button = n
