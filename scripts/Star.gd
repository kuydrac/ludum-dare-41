extends Node

export (int) var speed = 350
const dir = Vector2(0,1)
var star_types = ["close", "normal", "far"]

func _ready():
	var star_type_idx = randi() % 6
	var star_type = "normal"
	match(star_type_idx):
		0,1,2: star_type = "far"
		3,4: star_type = "normal"
		5: star_type = "close"
	$AnimatedSprite.animation = star_type
	match(star_type):
		"close": speed = 400
		"far": speed = 200
		_: speed = 300
	$AnimatedSprite.play()

func _process(delta):
	$AnimatedSprite.position += dir * speed * delta


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()

func set_position(pos):
	$AnimatedSprite.position = pos
