extends RigidBody2D

const TYPE = "enemy"

export (int) var speed = 100
export (int) var health = 20

var goal_pos = Vector2()
var screensize = Vector2()

func _ready():
	screensize = get_viewport_rect().size
	position.y = -32
	position.x = randi() % int(screensize.x)
	$LeaveTimer.wait_time = rand_range(10, 20)
	$LeaveTimer.start()
	$AnimatedSprite.play()

func _process(delta):
	var velocity = Vector2()
	velocity = goal_pos - position
	if velocity.length() > (speed * delta):
		velocity = velocity.normalized() * speed
		position += velocity * delta
	else:
		set_new_goal_pos()


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

func damage(amount):
	health -= amount
	if health <= 0:
		hide()
		$CollisionShape2D.disabled = true
		queue_free()


func _on_Enemy1_body_entered(body):
	if "TYPE" in body and "player_owner" in body:
		if body.TYPE == "bullet" and body.player_owner:
			var amount = body.health
			body.damage(amount)
			damage(amount)
