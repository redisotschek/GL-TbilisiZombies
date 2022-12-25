extends Node2D

var damage = 10.0

func _ready():
	hide()

func remove_bullet(body):
	queue_free()


func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		queue_free()
