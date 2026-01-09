class_name GoalArea extends Area2D

signal goal

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var animation_player_2: AnimationPlayer = $"../AnimationPlayer2"

func _ready() -> void:
	if not area_entered.is_connected(_area_entered):
		area_entered.connect(_area_entered)
	animation_player.play("goal_large")
	animation_player_2.play("goal_small")

func _area_entered(a: Area2D) -> void:
	if a is HurtBox:
		goal.emit()
