extends Node2D

@onready var shine_sprite: Sprite2D = $ShineSprite
@onready var arrow_sprite: Sprite2D = $ArrowSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not animation_player.is_playing():
		animation_player.play("selection")
	if PlayerManager.player == null:
		shine_sprite.visible = false
		arrow_sprite.visible = false
		return
	else:
		shine_sprite.visible = true
		arrow_sprite.visible = true
	
	if PlayerManager.player.collision.disabled:
		for c in LevelManager.level.get_children():
			if c is Skill:
				if c.player == PlayerManager.player:
					global_position = c.sprite.global_position + Vector2(0, 7)
					if c is SquareSkill and shine_sprite.scale.x < 2:
						shine_sprite.scale *= 2
						arrow_sprite.scale *= 2
						arrow_sprite.offset.y += -20
	else:
		if shine_sprite.scale.x > 1:
			shine_sprite.scale /= 2
			arrow_sprite.scale /= 2
			arrow_sprite.offset.y -= -20
		
		global_position = PlayerManager.player.body_sprite.global_position + Vector2(0, 7)
