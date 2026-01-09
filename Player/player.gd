class_name Player extends RigidBody2D

const SQUARE_SKILL = preload("uid://ufbjou2ocit7")
const MOON_SKILL = preload("uid://bwelnprp8q1h8")

@export var jump_speed := 400.0
@export var move_speed := 400.0
@export var max_move_speed := 300.0
@export var reverse_mult := 4.0
@export var ground_friction := 800.0
@export var air_friction := 250.0
@export var push_strength := 60
@export var max_tilt_deg := 10.0
@export var max_jump_tilt_deg := 75.0
@export var tilt_correction_strength := 1.0 # 1.0 = hard clamp, <1 = soft
@export var getup_torque := 120000.0
@export var upright_speed := 1

@onready var button: Button = $Sprite2D/BodySprite/Button
@onready var animation_player: AnimationPlayer = $AnimationPlayer_Square
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var player_sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var feet_cast: ShapeCast2D = $ShapeCast2D
@onready var does_not_rotate: Node2D = $DoesNotRotate
@onready var collision: CollisionPolygon2D = $CollisionPolygon2D
@onready var body_sprite: Sprite2D = $Sprite2D/BodySprite
@onready var feet_sprite: Sprite2D = $Sprite2D/FeetSprite
@onready var mouth_sprite: Sprite2D = $Sprite2D/MouthSprite
@onready var eyes_sprite: Sprite2D = $Sprite2D/EyesSprite
@onready var animations: Node2D = $Sprite2D/Animations
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var top_detector: Area2D = $TopDetector

var horizontal_direction : float = 0
var player_active : bool = false
var standing : bool = false
var player_spawned : bool = false
var between_max_rotation : bool = true
var between_max_jump_rotation : bool = true
var count_pushed_players : int
var contacted_floor : bool = false
var type : String
var skill_activated : bool = false
var movement_disabled : bool = false
var players_on_top : int = 0
var top_players_array : Array[Player] = []
var current_platform : Player = null
var prev_pos : Vector2
var moon_array : PackedVector2Array

func _ready() -> void:
	if not button.pressed.is_connected(_on_button_pressed):
		button.pressed.connect(_on_button_pressed)
	if not top_detector.body_entered.is_connected(_on_top_entered):
		top_detector.body_entered.connect(_on_top_entered)
	if not top_detector.body_exited.is_connected(_on_top_exited):
		top_detector.body_exited.connect(_on_top_exited)
	
	state_machine.initialize(self)
	
	prev_pos = global_position

func _process(_delta: float) -> void:
	if not movement_disabled and player_active:
		horizontal_direction = Input.get_axis("move_left", "move_right")
	if state_machine.current_state != state_machine.states[1]:
		var max_tilt := deg_to_rad(max_tilt_deg)
		var max_jump_tilt := deg_to_rad(max_jump_tilt_deg)
		if rotation > max_tilt or rotation < -max_tilt:
			between_max_rotation = false
		else:
			between_max_rotation = true
		if rotation > max_jump_tilt or rotation < -max_jump_tilt:
			between_max_jump_rotation = false
		else:
			between_max_jump_rotation = true
	
	if type == "Triangle":
		if skill_activated and is_on_floor():
			skill_activated = false

func _physics_process(_delta: float) -> void:
	if is_on_floor() and state_machine.current_state != state_machine.states[2] and linear_velocity.y < 0.0:
		linear_velocity.y = 0.0
	
	does_not_rotate.global_rotation = 0.0
	does_not_rotate.global_position = global_position + Vector2(0, 10)
	animations.scale.x = player_sprite.scale.x
	
	if global_position.x > get_viewport_rect().size.x or global_position.y > get_viewport_rect().size.y:
		global_position = prev_pos
	if prev_pos != global_position:
		prev_pos = global_position

func is_rider() -> Player:
	for p in PlayerManager.players:
		if p.top_players_array.size() > 0:
			if p.top_players_array.has(self) and p.linear_velocity.y != 0:
				return p
	return null

func is_on_floor() -> bool:
	if feet_cast.enabled:
		feet_cast.force_shapecast_update()
		return feet_cast.is_colliding()
	return false

func _on_button_pressed() -> void:
	if player_active:
		return
	
	for p in PlayerManager.players:
		if p == self:
			PlayerManager.player = p
			PlayerManager.player_changed.emit()
			if not player_active:
				player_active = true
			Selection.visible = true
			if not standing:
				stand_and_sit()
		else:
			if p.player_active:
				p.horizontal_direction = 0
				p.stand_and_sit()
			p.player_active = false

func update_animation(animation_name: String) -> void:
	animation_player.play(animation_name)

func stand_and_sit() -> void:
	standing = not standing
	
	if standing:
		animation_player.play("stand")
		Selection.animation_player.play("selection")
	else:
		animation_player.play("sit")
		Selection.animation_player.stop()

func _on_top_entered(n : Node) -> void:
	if n is Player and n != self:
		players_on_top += 1
		players_on_top = clampi(players_on_top, 0, 20)
		if not top_players_array.has(n):
			top_players_array.append(n)
		n.current_platform = self

func _on_top_exited(n : Node) -> void:
	if n is Player and n != self:
		players_on_top -= 1
		players_on_top = clampi(players_on_top, 0, 20)
		top_players_array.erase(n)
		if n.current_platform == self:
			n.current_platform = null

func is_being_pushed() -> bool:
	if horizontal_direction != 0:
		var p := false
		var x := false
		for i in range(get_contact_count()):
			for c in get_colliding_bodies():
				if c is Player:
					if c.player_active:
						p = true
					if  c != self:
						x = true
		if p and x:
			return true
	return false

func is_pushing() -> bool:
	if player_active and is_being_pushed():
		return true
	return false

func is_moving_toward_me() -> bool:
	for p in PlayerManager.players:
		if p.player_active:
			var move_dir := signf(p.linear_velocity.x)
			var toward := p.global_position.x - global_position.x
			if move_dir != 0 and signf(toward) == move_dir:
				return move_dir != 0 and signf(toward) == move_dir
	return false

func lift_group() -> void:
	await get_tree().physics_frame
	
	contact_monitor = true
	var overlapped = get_colliding_bodies()
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

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	contacted_floor = false
	for i in range(state.get_contact_count()):
		var n := state.get_contact_local_normal(i)
		if n.dot(Vector2.UP) > 0.65:
			contacted_floor = true
			break

func kill_player() -> void:
	for p in PlayerManager.players:
		if p == self:
			PlayerManager.players.erase(p)
	PlayerManager.player = null
	queue_free()

func _unhandled_input(event: InputEvent) -> void:
	if player_active and event.is_action_pressed("skill"):
		match type:
			"Square":
				var s : SquareSkill = SQUARE_SKILL.instantiate()
				if skill_activated:
					AudioManager.box_break_2.pitch_scale = randf_range(0.95, 1.05)
					AudioManager.box_break_2.play()
					s._square_skill_off(self)
					animation_player.play("RESET")
					s.queue_free()
				else:
					AudioManager.box_break_1.pitch_scale = randf_range(0.95, 1.05)
					AudioManager.box_break_1.play()
					animation_player.play("grow")
					await animation_player.animation_finished
					s._square_skill_on(self, s)
			"Triangle":
				if skill_activated:
					pass
				else:
					if not is_on_floor():
						skill_activated = true
						AudioManager.jump_2.pitch_scale = randf_range(0.95, 1.05)
						AudioManager.jump_2.play()
						apply_impulse(Vector2(rotation * jump_speed, -jump_speed))
						eyes_sprite.visible = false
						feet_sprite.visible = false
						mouth_sprite.visible = false
						movement_disabled = true
						await get_tree().create_timer(0.5).timeout
						movement_disabled = false
						eyes_sprite.visible = true
						feet_sprite.visible = true
						mouth_sprite.visible = true
						player_active = true
						standing = true
						_on_button_pressed()
			"Circle":
				if skill_activated:
					pass
				else:
					effect_animation_player.play("bomb")
					AudioManager.bomb_timer.play()
					await get_tree().create_timer(3.0).timeout
					AudioManager.bomb_timer.stop()
					effect_animation_player.stop()
					movement_disabled = true
					freeze = true
					body_sprite.visible = false
					feet_sprite.visible = false
					eyes_sprite.visible = false
					mouth_sprite.visible = false
					effect_animation_player.play("explode")
					for c in LevelManager.level.get_children():
						if c is BreakableWall:
							c.find_explosion(self)
					await effect_animation_player.animation_finished
					kill_player()
			"Moon":
				var m : MoonSkill = MOON_SKILL.instantiate()
				if skill_activated:
					AudioManager.ding.pitch_scale = randf_range(0.95, 1.05)
					AudioManager.ding.play()
					m._moon_skill_off(self)
					m.queue_free()
				else:
					AudioManager.ding.pitch_scale = randf_range(0.95, 1.05)
					AudioManager.ding.play()
					m._moon_skill_on(self, m)

func _create_moon() -> void:
	gravity_scale = 0.5
	move_speed = move_speed / 2
	max_move_speed = max_move_speed / 2
	jump_speed = jump_speed / 1.5
	center_of_mass_mode = RigidBody2D.CENTER_OF_MASS_MODE_CUSTOM
	center_of_mass = Vector2(0, -10)
	mass = 0.9

func set_type(_type : String) -> void:
	type = _type
	match type:
		"Square":
			body_sprite.texture = preload("res://Player/Sprites/Square.png")
			animation_player = $AnimationPlayer_Square
			var color := Color(0.0, 0.608, 1.0, 1.0)
			feet_sprite.modulate = color
			mouth_sprite.modulate = color
			body_sprite.modulate = color
			Selection.arrow_sprite.modulate = color
		"Triangle":
			body_sprite.texture = preload("res://Player/Sprites/Triangle.png")
			animation_player = $AnimationPlayer_Triangle
			var color := Color(1.0, 1.0, 0.0, 1.0)
			feet_sprite.modulate = color
			mouth_sprite.modulate = color
			body_sprite.modulate = color
			Selection.arrow_sprite.modulate = color
		"Circle":
			body_sprite.texture = preload("res://Player/Sprites/Circle.png")
			animation_player = $AnimationPlayer_Circle
			var color := Color(0.0, 0.663, 0.0, 1.0)
			feet_sprite.modulate = color
			mouth_sprite.modulate = color
			body_sprite.modulate = color
			Selection.arrow_sprite.modulate = color
		"Moon":
			body_sprite.texture = preload("res://Player/Sprites/Moon.png")
			animation_player = $AnimationPlayer_Moon
			var color := Color(1.0, 0.553, 1.0, 1.0)
			feet_sprite.modulate = color
			mouth_sprite.modulate = color
			body_sprite.modulate = color
			Selection.arrow_sprite.modulate = color
