extends KinematicBody2D

export(int) var speed = 100
export(float, 0, 1.0) var friction = 0.1
export(float, 0, 1.0) var acceleration = 0.25
export(int) var jump_speed = -500
export(int) var gravity = 2000

var velocity = Vector2.ZERO

var grounded = false

onready var sprite = $AnimatedSprite
onready var trail_left = $Trail_left
onready var trail_right = $Trail_right
onready var dash_timer = $Dash_timer
var dashing = false

var bullet = preload("res://Scenes/Bullet.tscn")
onready var right_fire_point = $Right_fire_point
onready var left_fire_point = $Left_fire_point

func get_movement_input():
	var dir = 0
	if Input.is_action_pressed("ui_right"):
		dir += 1
	if Input.is_action_pressed("ui_left"):
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
		
func _physics_process(delta):
	get_movement_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_speed
			
	if Input.is_action_just_pressed("dash"):
		dash()
		
	if Input.is_action_just_pressed("fire"):
		fire()
		
			
	# Sprites
	
	if dashing == true:
		sprite.play("Dash")
	else:
		if abs(velocity.x) > 20:
			sprite.play("Run")
		else:
			sprite.stop()
			sprite.play("Idle")
			
		if !is_on_floor():
			sprite.play("Jump")
		
	if velocity.x < 0:
		sprite.flip_h = true
	if velocity.x > 0:
		sprite.flip_h = false
		
	
		
func dash():
	speed = 300
	dashing = true
	
	if sprite.flip_h == true:
		trail_right.restart()
		trail_right.emitting = true
	else:
		trail_left.restart()
		trail_left.emitting = true
		
	if abs(velocity.x) < 50:
		if sprite.flip_h == true:
			velocity.x -= 100
		else:
			velocity.x += 100

	dash_timer.start()
	
func _on_Dash_timer_timeout():
	speed = 100
	dashing = false
	trail_left.emitting = false
	trail_right.emitting = false
	
func fire():
	var bullet_instance = bullet.instance()
	var bullet_dir
	var fire_point
	
	if sprite.flip_h == true:
		bullet_dir = -1
		fire_point = left_fire_point
	else:
		bullet_dir = 1
		fire_point = right_fire_point
	
	bullet_instance.start(fire_point.global_position, bullet_dir)
	
	var scene_root = get_tree().root.get_children()[0]
	scene_root.add_child(bullet_instance)
		
func die():
	get_tree().reload_current_scene()
