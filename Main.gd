extends Node

export (PackedScene) var mob_scene
export (PackedScene) var mega_mob_scene
export (PackedScene) var bullet_scene

var Player: Object = null
var score = 0
var is_recoil = true
var bullet_speed = 600.0
var mob_count = 5

var default_hp = 100

var Health_Bar: Object = null

func _ready():
	randomize()
	Player = $Player
	Health_Bar = $HUD/HealthBar
	Health_Bar.hide()

func new_game():
	score = 0
	$HUD.update_score(score)
	
	Health_Bar.set_value(default_hp)
	Health_Bar.show()
	
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartPosition.position)
	$Music.play()
	$StartTimer.start()
	
	$HUD.show_message("Get ready")
	yield($StartTimer, "timeout")
	$ScoreTimer.start()
	$MobTimer.start()
	spawn_mobs()
	is_recoil = false	
	
func take_damage(damage):
	Health_Bar.deplete(damage)
	if Health_Bar.value <= 0:
		Player.die()
		game_over()
	
func game_over():
	is_recoil = true
	$FireTimer.stop()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$FireTimer.stop()
	$MobIncreaseTimer.stop()
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
	spawn_mobs()

func spawn_mobs():
	for i in range(mob_count):
		var mob_spawn_location = $MobPath/MobSpawnLocation
		mob_spawn_location.unit_offset = randf()
		var mob = mob_scene.instance()
		add_child(mob)
		mob.position = mob_spawn_location.position
		
func _on_MobIncreaseTimer_timeout():
	mob_count += 3

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_FireTimer_timeout():
	is_recoil = false


func _on_MegaMobTimer_timeout():
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.unit_offset = randf()
	
	var mega_mob = mega_mob_scene.instance()
	add_child(mega_mob)
	mega_mob.position = mob_spawn_location.position

