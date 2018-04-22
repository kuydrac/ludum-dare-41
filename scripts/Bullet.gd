extends RigidBody2D

const dir = Vector2(0,-1)
const TYPE = "bullet"
var player_owner = true
var health = 1

export (int) var speed = 500

func _ready():
	pass

func _process(delta):
	position += dir * speed * delta


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()

func set_color(color):
	$Sprite.set_modulate(color)

func damage(amount):
	health -= amount
	if health <= 0:
		hide()
		$CollisionShape2D.disabled = true
		queue_free()
