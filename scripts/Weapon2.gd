extends Node

const bullet = preload("res://scenes/Bullet.tscn")
const LEVEL = 2
var max_wait = 1.0/(1 + LEVEL)
var wait_reduction = 0.25/LEVEL
var weapon_color = Color()
var player_owned = false

func _ready():
	pass

#func _process(delta):

func fire():
	if $Cooldown.is_stopped():
		var bul = bullet.instance()
		add_child(bul)
		bul.set_color(weapon_color)
		bul.position = $Position2D.position + Vector2(10,0)
		if player_owned:
			bul.dir = -bul.dir
			bul.player_owned = true
			bul.health = 5
		bul = bullet.instance()
		add_child(bul)
		bul.set_color(weapon_color)
		bul.position = $Position2D.position - Vector2(10,0)
		if player_owned:
			bul.dir = -bul.dir
			bul.player_owned = true
			bul.health = 4
		$Cooldown.start()

func set_power(power):
	var wait = max_wait
	power = clamp(power, 1, 14)
	wait -= (wait_reduction * (power - 1) / 13)
	$Cooldown.wait_time = wait

func set_position(pos):
	$Position2D.position = pos