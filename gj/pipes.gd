extends Node2D

@export var speed: float = 200.0

signal passed

var scored = false

func _process(delta):
	position.x -= speed * delta
	
	if position.x < -100:
		queue_free()

func _on_score_area_body_entered(body):
	if not scored:
		scored = true
		emit_signal("passed")
