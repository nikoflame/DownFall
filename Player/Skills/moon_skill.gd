class_name MoonSkill extends Skill

@onready var collision: CollisionPolygon2D = $CollisionShape2D
@onready var button: Button = $Sprite2D/Button
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	if not button.pressed.is_connected(_on_button_pressed):
		button.pressed.connect(_on_button_pressed)

func _process(_delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	for p in PlayerManager.players:
		if p == player:
			PlayerManager.player = p
			PlayerManager.player_changed.emit()
			if not p.player_active:
				p.player_active = true
			Selection.visible = true
		else:
			if p.player_active:
				p.stand_and_sit()
			p.player_active = false

func _moon_skill_off(p : Player) -> void:
	for s in LevelManager.level.get_children():
		if s is MoonSkill:
			if s.player == p:
				p.freeze = false
				p.linear_velocity = Vector2(0, 0)
				p.angular_velocity = 0.0
				p.movement_disabled = false
				s.collision.disabled = true
				s.visible = false
				p.global_position = s.global_position + Vector2(0, 0)
				p.rotation = s.rotation
				p.collision.disabled = false
				p.button.disabled = false
				p.visible = true
				s.queue_free()
				p.player_active = true
				p.standing = true
				p._on_button_pressed()
				p.skill_activated = false

func _moon_skill_on(p : Player, m : MoonSkill) -> void:
	p.linear_velocity = Vector2(0, 0)
	p.angular_velocity = 0.0
	p.freeze = true
	p.movement_disabled = true
	m.player = p
	p.collision.disabled = true
	p.button.disabled = true
	p.visible = false
	m.global_position = p.global_position + Vector2(0, 0)
	m.rotation = p.rotation
	LevelManager.level.add_child(m)
	m.freeze = true
	p.skill_activated = true
