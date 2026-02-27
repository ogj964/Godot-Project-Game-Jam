extends CharacterBody2D

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -450.0

var isAttacking: bool = false
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction_x: float = Input.get_axis("left", "right")

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Horizontal movement
	velocity.x = direction_x * SPEED

	# Flip sprite based on direction
	if direction_x > 0:
		animated_sprite.flip_h = false
	elif direction_x < 0:
		animated_sprite.flip_h = true

	# Attack
	if Input.is_action_just_pressed("attack") and not isAttacking:
		isAttacking = true
		animated_sprite.play("attack")
	
	# Movement animations (only if not attacking)
	elif not isAttacking:
		if direction_x != 0:
			animated_sprite.play("walk")
		else:
			animated_sprite.play("idle")

	# Move the character
	move_and_slide()

# Called when attack animation finishes
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "attack":
		isAttacking = false
