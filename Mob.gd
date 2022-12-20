extends RigidBody2D

signal kill

var player
var speed
export var min_speed = 20.0
export var max_speed = 50.0

func _ready():
	var player_node = NodePath(@"/root/Main/Player:position")
	player = get_node(player_node)
	speed = rand_range(min_speed, max_speed)
#	$AnimatedSprite.play()
#	var mob_types = $AnimatedSprite.frames.get_animation_names()
#	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

func _process(delta):
	var direction = (player.position - self.position).normalized()
	turn(player)
	position += direction * speed * delta

func turn(target):
	var global_pos = global_transform.origin
	var player_pos = target.global_transform.origin
	var _rotation = player_pos - global_pos
	rotation = _rotation.angle()

func _on_VisibilityNotifier2D_screen_exited():
	die()


func die():
	queue_free()



func _on_Mob_body_entered(body):
	if body.is_in_group("ammo"):
		die()
