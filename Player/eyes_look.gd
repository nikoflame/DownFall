class_name EyesLook extends Node2D

var mouse_pos : Vector2
var dir : Vector2
var dist : float
var max_dist : float = 3.5

@onready var eyes_sprite: Sprite2D = $"../EyesSprite"

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	mouse_pos = get_local_mouse_position()
	dir = Vector2.ZERO.direction_to(mouse_pos)
	dist = mouse_pos.length()
	
	if abs(mouse_pos.x) < max_dist:
		if sign(dir.y) == -1:
			#looking up
			eyes_sprite.frame = 1
		else:
			#looking down
			eyes_sprite.frame = 0
	elif dist > max_dist:
		if sign(dir.x) == -1:
			if sign(dir.y) == -1:
				#looking left and up
				eyes_sprite.frame = 2
			else:
				#looking left and down
				eyes_sprite.frame = 3
		else:
			if sign(dir.y) == -1:
				#looking right and up
				eyes_sprite.frame = 5
			else:
				#looking right and down
				eyes_sprite.frame = 4
	else:
		#looking down
		eyes_sprite.frame = 0
