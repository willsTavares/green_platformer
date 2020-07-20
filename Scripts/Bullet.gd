extends Area2D


onready var time_to_live = $Time_to_live
var speed = 400
var timer = 0
var hit = false


func _ready():
	time_to_live.start()
	$Bullet.connect("body_entered", self, "collided")
	
	
func _physics_process(delta):
	var dir = global_transform.x.normalized()
	global_translate(dir * speed * delta)
	

func _on_Time_to_live_timeout():
	queue_free()

func collided(body):
	hit = true
	queue_free()
