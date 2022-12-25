extends RigidBody2D

signal kill

var player
var speed
var hp: float = 20.0
export var min_speed = 20.0
export var max_speed = 50.0
var damage = 10

func _ready():
	var player_node = NodePath(@"/root/Main/Player:position")
	player = get_node(player_node)
	speed = rand_range(min_speed, max_speed)
	$HealthBar.value = hp
	$HealthBar.max_value = hp
#	$AnimatedSprite.play()
#	var mob_types = $AnimatedSprite.frames.get_animation_names()
#	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

func _process(delta):
	if player.position.distance_to(self.position) > 1:
		var direction = (player.position - self.position).normalized()
		turn(player)
		position += direction * speed * delta

func turn(target):
	var global_pos = global_transform.origin
	var player_pos = target.global_transform.origin
	var _rotation = player_pos - global_pos
	$Sprite.rotation = _rotation.angle() + PI / 2

func take_damage(damage):
	hp -= damage
	$HealthBar.value = hp
	if hp <= 0:
		die()

func _on_VisibilityNotifier2D_screen_exited():
	die()


func die():
	emit_signal("kill")
	queue_free()


func _on_Mob_body_entered(body):
	if body.is_in_group("ammo"):
		take_damage(body.damage)


func _on_Mob_mouse_entered():
	pass
	print("hello")
	$HealthBar.show()


func _on_Mob_mouse_exited():
	pass
	print("bye")	
	$HealthBar.hide()
