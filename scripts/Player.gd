extends Area2D

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

func damage(amount):
	health -= amount
	if health <= 0:
		hide()
		$CollisionShape2D.disabled = true

func _on_Player_area_entered(area):
	if "TYPE" in area:
		if area.TYPE == "enemy":
			var amount = area.health
			area.damage(amount)
			damage(amount)
		elif "player_owner" in area:
			if area.TYPE == "bullet" and area.player_owner == false:
				var amount = area.health
				area.damage(amount)
				damage(amount)
