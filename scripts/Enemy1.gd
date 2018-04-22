extends Area2D

const TYPE = "enemy"

export (int) var speed = 100
export (int) var health = 20

var goal_pos = Vector2()
var screensize = Vector2()
var card

func _ready():
	screensize = get_viewport_rect().size
	position.y = -32
	position.x = randi() % int(screensize.x)
	$LeaveTimer.wait_time = rand_range(20, 30)
	$LeaveTimer.start()
	$AnimatedSprite.play()
	card = get_random_card()
	$WeaponSystem.add_card(card)

func _process(delta):
	var velocity = Vector2()
	velocity = goal_pos - position
	if velocity.length() > (speed * delta):
		velocity = velocity.normalized() * speed
		position += velocity * delta
		$WeaponSystem.set_position(position)
	else:
		set_new_goal_pos()
		
	$WeaponSystem.fire_weapon()

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()

func set_goal_pos(pos):
	goal_pos = pos
	
func set_new_goal_pos():
	var new_pos = position
	new_pos.x += rand_range(-64, 64)
	new_pos.y += rand_range(-64, 64)
	
	new_pos.x = clamp(new_pos.x, 0, screensize.x)
	new_pos.y = clamp(new_pos.y, 0, screensize.y)
	
	set_goal_pos(new_pos)

func _on_LeaveTimer_timeout():
	var new_pos = position
	new_pos.x += rand_range(-64, 64)
	new_pos.x = clamp(new_pos.x, 0, screensize.x)
	new_pos.y = screensize.y + 1000
	set_goal_pos(new_pos)

func damage(amount, bullet = false, color = $WeaponSystem.dark_red_color):
	if bullet:
		if $WeaponSystem.get_weapon_color() == $WeaponSystem.red_color:
			if color == $WeaponSystem.black_color:
				amount *= 2
			elif color == $WeaponSystem.red_color:
				amount /= 2
		elif $WeaponSystem.get_weapon_color() == $WeaponSystem.black_color:
			if color == $WeaponSystem.black_color:
				amount /= 2
			elif color == $WeaponSystem.red_color:
				amount *= 2
		elif $WeaponSystem.get_weapon_color() == $WeaponSystem.dark_red_color:
			if color == $WeaponSystem.dark_red_color:
				amount /= 2
	health -= amount
	if health <= 0:
		
		hide()
		$CollisionShape2D.disabled = true
		queue_free()

func _on_Enemy1_area_entered(area):
	if "TYPE" in area and "player_owned" in area:
		if area.TYPE == "bullet" and area.player_owned:
			var amount = area.health
			area.damage(amount)
			damage(amount, true, area.bullet_color)

func get_random_card():
	var rank = rand_range(2,15)
	var suits = ["S", "C", "H", "D"]
	var suit = suits[randi() % suits.size()]
	var card = $WeaponSystem.Card.new()
	card.rank = rank
	card.suit = suit
	return card
