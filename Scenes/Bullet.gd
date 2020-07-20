extends Area2D


onready var time_to_live = $Time_to_live
var speed = 400
var velocity = Vector2()
var timer = 0
var hit = false

func _ready():
	time_to_live.start()

func start(pos, dir):
	position = pos
	velocity = Vector2(speed * dir, 0)
	
func _physics_process(delta):
	position += velocity * delta

func _on_Time_to_live_timeout():
	queue_free()

func collided(body):
	hit = true
	queue_free()
