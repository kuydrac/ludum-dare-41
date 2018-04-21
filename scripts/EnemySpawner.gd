extends Node

const enemy1 = preload("res://scenes/Enemy1.tscn")

var screensize = Vector2()
var level = 1

func _ready():
	screensize = get_viewport().get_visible_rect().size

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func spawn_enemy():
	var pos = Vector2()
	var enemy = enemy1.instance()
	add_child(enemy)
	
	pos = enemy.position
	pos.x += rand_range(-64, 64)
	pos.y = rand_range(0, screensize.y / 3)
	enemy.set_goal_pos(pos)
	

func _on_SpawnTimer_timeout():
	spawn_enemy()
	$SpawnTimer.wait_time = rand_range(1, 5)
