extends CharacterBody2D

const SPEED = 120
const DAMAGE = 10

var health = 50
var isDead = false
var attackCooldown = false

@onready var sprite = $AnimatedSprite2D

var player

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if isDead:
		return
		
	if player == null:
		return
	
	# Move toward player
	var direction = sign(player.global_position.x - global_position.x)
	velocity.x = direction * SPEED
	
	# Flip sprite
	sprite.flip_h = direction < 0
	
	move_and_slide()


func take_damage(amount):
	if isDead:
		return
		
	print("Enemy took damage")  # DEBUG
	
	health -= amount
	
	if health <= 0:
		die()


func die():
	isDead = true
	velocity = Vector2.ZERO
	sprite.play("death")


func _on_body_entered(body):
	if body.is_in_group("player") and !attackCooldown:
		print("Enemy hit player")  # DEBUG
		body.take_damage(DAMAGE)
		attackCooldown = true
		await get_tree().create_timer(1.0).timeout
		attackCooldown = false
