class_name TitleShape extends Node2D

var running : bool = false
var parent_rotation : float
var parent_rotation_prev : float = 15000000

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if StartMenu.visible:
		if not running:
			animate_random_rotation()
		
		if name != "SquareNode":
			parent_rotation = get_parent().rotation
			if parent_rotation_prev == 15000000:
				parent_rotation_prev = parent_rotation
			else:
				if parent_rotation != parent_rotation_prev:
					parent_rotation_prev = parent_rotation
					rotation -= parent_rotation_prev - parent_rotation

func animate_random_rotation():
		running = true
		await get_tree().create_timer(randf_range(0.5, 2.0)).timeout
		var tween = create_tween()
		var target_rotation : float
		var rotation_min = 1
		if name == "TriangleNode":
			rotation_min = 2.5
		elif name == "CircleNode":
			rotation_min = 5
		target_rotation = clampf(rotation_degrees + randi_range(-5, 5), -rotation_min, rotation_min)
		var duration = 0.5
		tween.tween_property(self, "rotation_degrees", target_rotation, duration).set_ease(Tween.EASE_OUT)
		await tween.finished
		running = false
