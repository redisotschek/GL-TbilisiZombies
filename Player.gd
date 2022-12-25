extends Area2D

signal hit
signal shoot
var direction = Vector2.ZERO
var _smoother_mouse_position: Vector2
onready var sprite = get_node("Sprite")

export var speed = 100.0
var screen_size = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	direction = Vector2.ZERO
	_smoother_mouse_position = lerp(_smoother_mouse_position, get_global_mouse_position(), 1.0)
	sprite.look_at(_smoother_mouse_position)
	sprite.rotation += PI / 2
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
		
	
func die():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)

func start(new_position):
	position = new_position
	show()
	$CollisionShape2D.disabled = false

func _on_Player_body_entered(body):
	if body.is_in_group("mobs"):
		emit_signal("hit", body.damage)


func _on_MobileJoystick_use_move_vector(move_vector):
	direction = move_vector
