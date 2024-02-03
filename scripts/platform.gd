extends Area2D


class_name Platform

func _ready():
	pass # Replace with function body.


func _process(_delta):
	pass


func _on_body_entered(body):
	if not body is Player:
		return
	
	if body.velocity.y > 0:
		body.jump()
