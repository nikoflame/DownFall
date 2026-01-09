class_name SquareSkill extends Skill

@onready var collision: CollisionShape2D = $CollisionShape2D
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

func _square_skill_off(p : Player) -> void:
	for s in LevelManager.level.get_children():
		if s is SquareSkill:
			if s.player == p:
				s.collision.disabled = true
				s.visible = false
				p.global_position = s.global_position + Vector2(0, 0)
				p.collision.disabled = false
				p.button.disabled = false
				p.visible = true
				p.freeze = false
				s.queue_free()
				p.player_active = true
				p.standing = true
				p._on_button_pressed()
				p.skill_activated = false

func _square_skill_on(p : Player, s : SquareSkill) -> void:
	s.player = p
	p.freeze = true
	p.collision.disabled = true
	p.button.disabled = true
	p.visible = false
	s.global_position = p.global_position + Vector2(0, 0)
	LevelManager.level.add_child(s)
	p.skill_activated = true
	
	await get_tree().physics_frame
	
	s.contact_monitor = true
	var overlapped = s.get_colliding_bodies()
	var players: Array = []
	for body in overlapped:
		if body is Player:
			players.append(body)
	
	if players.is_empty():
		return
	
	var x_bucket_size := 20.0 #width of players
	var columns := {}
	
	for pl in players:
		var key := int(round(pl.global_position.x / x_bucket_size))
		if not columns.has(key):
			columns[key] = []
		columns[key].append(pl)
	
	var lift_amount := 20.0 #amount to lift stack by
	var spacing := 2.0 #spacing between players
	
	for key in columns.keys():
		var col: Array = columns[key]
		col.sort_custom(func(a, b):
			return a.global_position.y > b.global_position.y
		)
		
		for pl in col:
			if "velocity" in pl:
				pl.velocity = Vector2.ZERO
			if "linear_velocity" in pl:
				pl.linear_velocity = Vector2.ZERO
			if "angular_velocity" in pl:
				pl.angular_velocity = 0.0
		
		var base_y = col[0].global_position.y - lift_amount
		
		for i in range(col.size()):
			var pl: Node2D = col[i]
			pl.global_position.y = base_y - float(i) * spacing
