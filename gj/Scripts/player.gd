extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -450.0

var isAttacking = false
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction_x := Input.get_axis("left", "right")

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement
	velocity.x = direction_x * SPEED

	# Flip sprite based on direction
	if direction_x > 0:
		animated_sprite.flip_h = false
	elif direction_x < 0:
		animated_sprite.flip_h = true

	# Attack
	if Input.is_action_just_pressed("attack") and !isAttacking:
		isAttacking = true
		animated_sprite.play("attack")

	# Movement animations (only if not attacking)
	elif !isAttacking:
		if direction_x != 0:
			animated_sprite.play("walk")
		else:
			animated_sprite.play("idle")

	move_and_slide()


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "attack":
		isAttacking = false
