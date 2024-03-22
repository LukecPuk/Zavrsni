extends CharacterBody2D

var health = 100
var movement_speed = 60.0

#Attacks
var iceSpear = preload("res://Scenes/Player/Attacks/ice_spear_attack.tscn")

#AttackNodes
@onready var iceSpearTimer = get_node("%IceSpearTimer")
@onready var iceSpearAttackTimer = get_node("%AttackTimer")

#IceSpear
var icespear_ammo = 0
var icespear_baseammo = 1
var icespear_attackspeed = 1.5
var icespear_level = 1

#Enemy Related
var enemy_close = []

@onready var sprite = $Sprite2D
@onready var walkTimer = %WalkTimer



func _ready():
	attack()

func _physics_process(delta):
	movement()

func movement():
	var input_direction = Input.get_vector("left","right","up","down")
	
	if input_direction.x > 0:
		sprite.flip_h = true
	elif input_direction.x < 0: 
		sprite.flip_h = false
	
	if input_direction != Vector2.ZERO:
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes -1:
				sprite.frame = 0
			else: 
				sprite.frame += 1
			walkTimer.start()
	
	velocity = input_direction * movement_speed
	move_and_slide()

func attack():
	if icespear_level > 0:
		iceSpearTimer.wait_time = icespear_attackspeed
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()

func _on_hurtbox_hurt(damage, _angle, _knockback):
	health -= damage


func _on_ice_spear_timer_timeout():
	icespear_ammo += icespear_baseammo
	iceSpearAttackTimer.start()


func _on_attack_timer_timeout():
	if icespear_ammo > 0:
		var is_attack = iceSpear.instantiate()
		is_attack.position = position
		is_attack.target = get_target()
		is_attack.level = icespear_level
		add_child(is_attack)
		icespear_ammo -= 1
		if icespear_ammo > 0:
			iceSpearAttackTimer.start()
		else:
			iceSpearAttackTimer.stop()

func get_target():
	var closest_distance = 10000
	var closest_enemy = null
	
	for enemy in enemy_close:
		var distance_to_enemy = enemy.global_position.distance_to(global_position)
		if distance_to_enemy < closest_distance:
			closest_distance = distance_to_enemy
			closest_enemy = enemy
	if closest_enemy:
		return closest_enemy.global_position
	else:
		return Vector2.RIGHT


func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)
