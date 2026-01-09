class_name TitleLetter extends Sprite2D

var running : bool = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if not running and StartMenu.visible:
		animate_random_rotation()

func animate_random_rotation():
	if (
		!StartMenu.d_ap.is_playing()
		and !StartMenu.o_ap.is_playing()
		and !StartMenu.w_ap.is_playing()
		and !StartMenu.n_ap.is_playing()
		and !StartMenu.f_ap.is_playing()
		and !StartMenu.a_ap.is_playing()
		and !StartMenu.l1_ap.is_playing()
		and !StartMenu.l2_ap.is_playing()
		and StartMenu.title_sequence_started
	):
		running = true
		await get_tree().create_timer(randf_range(0.5, 2.0)).timeout
		var tween = create_tween()
		var target_rotation = clampf(rotation_degrees + randi_range(-15, 15), -45, 45)
		var duration = 0.5
		tween.tween_property(self, "rotation_degrees", target_rotation, duration).set_ease(Tween.EASE_OUT)
		await tween.finished
		running = false
