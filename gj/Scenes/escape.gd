extends Node2D

@export var pipe_scene: PackedScene
@export var pipe_gap: float = 180.0
@export var spawn_height_min: float = 200.0
@export var spawn_height_max: float = 400.0

var score = 0
var game_over = false

@onready var bird = $CharacterBody2D
@onready var pipes = $pipes
@onready var timer = $SpawnTimer
@onready var score_label = $ScoreLabel
@onready var game_over_label = $GameOverLabel

func _ready():
	randomize()
	bird.died.connect(_on_bird_died)
	timer.timeout.connect(spawn_pipe)

func spawn_pipe():
	if game_over:
		return
	
	var pipe = pipe_scene.instantiate()
	pipe.position = Vector2(600, randf_range(spawn_height_min, spawn_height_max))
	
	pipe.passed.connect(_on_pipe_passed)
	pipes.add_child(pipe)

func _on_pipe_passed():
	score += 1
	score_label.text = "Score: " + str(score)

func _on_bird_died():
	game_over = true
	timer.stop()
	game_over_label.visible = true

func _process(delta):
	if game_over and Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()
