extends CharacterBody2D

const SPEED = 300
const JUMP_VELOCITY = -450
const DAMAGE = 25

var health = 100
var isAttacking = false
var isDead = false

@onready var sprite = $AnimatedSprite2D
@onready var hitbox = $Hitbox

func _ready():
	hitbox.monitoring = false

func _physics_process(delta):

	if isDead:
		return

	var direction = Input.get_axis("left", "right")

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	velocity.x = direction * SPEED

	# Flip sprite
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true

	# Attack
	if Input.is_action_just_pressed("attack") and !isAttacking:
		isAttacking = true
		sprite.play("attack")
		hitbox.monitoring = true

	elif !isAttacking:
		if direction != 0:
			sprite.play("walk")
		else:
			sprite.play("idle")

	move_and_slide()


func take_damage(amount):
	if isDead:
		return

	health -= amount
	sprite.play("hurt")

	if health <= 0:
		die()


func die():
	isDead = true
	velocity = Vector2.ZERO
	sprite.play("death")


func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "attack":
		isAttacking = false
		hitbox.monitoring = false
