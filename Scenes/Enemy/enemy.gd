extends CharacterBody2D

@export var health = 10
@export var movement_speed = 30.0

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer

func _ready():
	anim_player.play("walk")

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	move_and_slide()
	
	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < -0.1:
		sprite.flip_h = false

func _on_hurtbox_hurt(damage):
	health -= damage
	if health <= 0:
		queue_free()
