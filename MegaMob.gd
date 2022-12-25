extends RigidBody2D


var speed = 120.0
var player: Object

# Called when the node enters the scene tree for the first time.
func _ready():
	var player_node = NodePath(@"/root/Main/Player:position")
	player = get_node(player_node)

func _process(delta):
	if player.position.distance_to(self.position) > 1:
		var direction = (player.position - self.position).normalized()
		turn(player)
		position += direction * speed * delta
	

func turn(target):
	var global_pos = global_transform.origin
	var player_pos = target.global_transform.origin
	var _rotation = player_pos - global_pos
	rotation = _rotation.angle()
