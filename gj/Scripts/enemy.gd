extends CharacterBody2D

@export var speed := 150.0
@export var attack_range := 50.0

var player: CharacterBody2D

func _ready():
	# Enemy and Player must be siblings under the same parent
	player = get_parent().get_node("Player")
	if not player:
		push_error("Enemy could not find Player!")

func _physics_process(delta):
	if not player:
		return

	var direction = player.global_position - global_position
	var distance = direction.length()

	if distance > attack_range:
		direction = direction.normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		print("Enemy in attack range!")
