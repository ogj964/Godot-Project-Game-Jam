extends CharacterBody2D

@export var gravity: float = 900.0
@export var jump_force: float = -350.0
@export var max_fall_speed: float = 500.0

signal died

var is_alive = true

@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.play("flap")

func _physics_process(delta):
	if not is_alive:
		return

	velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_fall_speed)

	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_force

	move_and_slide()

	# Smooth tilt
	var target_rotation = clamp(velocity.y * 0.002, -0.5, 1.2)
	rotation = lerp(rotation, target_rotation, 8 * delta)

	# Check if off screen
	if position.y > 650 or position.y < -50:
		die()

func die():
	if not is_alive:
		return
	
	is_alive = false
	sprite.stop()
	emit_signal("died")
