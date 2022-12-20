extends Area2D

signal hit
signal shoot
var _smoother_mouse_position: Vector2

export var speed = 100.0
var screen_size = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	_smoother_mouse_position = lerp(_smoother_mouse_position, get_global_mouse_position(), 1.0)
	look_at(_smoother_mouse_position)
	rotation += PI / 2
	var direction = Vector2.ZERO
	if Input.is_mouse_button_pressed(1):
		emit_signal("shoot")
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1

	if direction.length() > 0:
		direction = direction.normalized()
		
	position += direction * speed * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y,0, screen_size.y)
		
	

func start(new_position):
	position = new_position
	show()
	$CollisionShape2D.disabled = false

func _on_Player_body_entered(body):
	pass
#	if body.is_in_group("mobs"):
#		hide()
#		$CollisionShape2D.set_deferred("disabled", true)
#		emit_signal("hit")
