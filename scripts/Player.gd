extends Area2D

const START_HEALTH = 100

export (int) var speed = 250
export (int) var health = 100

var screensize = Vector2()

func _ready():
	screensize = get_viewport_rect().size
	start(Vector2(0,0))
	$AnimatedSprite.play()

func _process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	velocity = velocity.normalized() * speed
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	$WeaponSystem.set_position(position)
	
	if Input.is_action_pressed("ui_fire"):
		$WeaponSystem.fire_weapon()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	$WeaponSystem.reset()
	$WeaponSystem.player_owned = true

func stop():
	hide()
	$CollisionShape2D.disabled = true

func game_over():
	stop()

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
		$WeaponSystem.remove_card()
		health = START_HEALTH

func _on_Player_area_entered(area):
	if "TYPE" in area:
		if area.TYPE == "enemy":
			var amount = area.health
			area.damage(amount)
			damage(amount)
		elif "player_owned" in area:
			if area.TYPE == "bullet" and area.player_owned == false:
				var amount = area.health
				area.damage(amount)
				damage(amount, true, area.bullet_color)


func _on_WeaponSystem_no_cards():
	game_over()
