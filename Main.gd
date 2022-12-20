extends Node

export (PackedScene) var mob_scene
export (PackedScene) var bullet_scene

var Player: Object = null
var score = 0
var is_recoil = true
var bullet_speed = 600.0

func _ready():
	randomize()
	Player = $Player

func new_game():
	score = 0
	$HUD.update_score(score)
	
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartPosition.position)
	$Music.play()
	$StartTimer.start()
	
	$HUD.show_message("Get ready")
	yield($StartTimer, "timeout")
	$ScoreTimer.start()
	$MobTimer.start()
	is_recoil = false
	
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func shoot():
	if !is_recoil:
		is_recoil = true
		$Gunshot.play()
		var bullet = bullet_scene.instance()
		add_child(bullet)
		bullet.show()
		
		var bullet_direction = (get_viewport().get_mouse_position() -  $Player.position).normalized()
		
		bullet.position = $Player.position
		var velocity = Vector2(bullet_speed, 0)
		bullet.rotation = bullet_direction.angle() + PI / 2
		bullet.linear_velocity = velocity.rotated(bullet_direction.angle())
		$FireTimer.start()

func _on_MobTimer_timeout():
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.unit_offset = randf()
	
	var mob = mob_scene.instance()
	add_child(mob)
	mob.position = mob_spawn_location.position


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_FireTimer_timeout():
	is_recoil = false
