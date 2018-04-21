extends Node

var screensize = Vector2()

func _ready():
	screensize = get_viewport().get_visible_rect().size
	$Player.start(Vector2(screensize.x / 2, screensize.y - 32))

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
