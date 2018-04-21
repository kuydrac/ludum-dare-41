extends Node

const starNode = preload("res://scenes/Star.tscn")

var screensize = Vector2()

func _ready():
	var pos = Vector2()
	screensize = get_viewport().get_visible_rect().size
	randomize()
	
	for i in range(10):
		pos.x = randi() % int(screensize.x)
		pos.y = randi() % int(screensize.y)
		spawn_star(pos)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func spawn_star(pos=null):
	var star = starNode.instance()
	if pos != null:
		star.set_position(pos)
	add_child(star)


func _on_StarTimer_timeout():
	var pos = Vector2()
	pos.x = rand_range(0, screensize.x / 3)
	pos.y = -rand_range(16, 24)
	spawn_star(pos)
	pos.x = rand_range(screensize.x / 3, 2 * screensize.x / 3)
	pos.y = -rand_range(16, 24)
	spawn_star(pos)
	pos.x = rand_range(2 * screensize.x / 3, screensize.x)
	pos.y = -rand_range(16, 24)
	spawn_star(pos)
	$StarTimer.wait_time = rand_range(0.2, 0.4)
