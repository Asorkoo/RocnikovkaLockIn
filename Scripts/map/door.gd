extends Node2D

@onready var sprite = $Sprite2D
@onready var static_body = $StaticBody2D
@onready var collision = $StaticBody2D/CollisionShape2D
@onready var area = $Area2D
@onready var label = $Label


var player_in_range = false
var is_open = false

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _process(delta):
	label.visible = player_in_range and not is_open
	if player_in_range and Input.is_action_just_pressed("interact"):
		toggle_door()

func toggle_door():
	is_open = !is_open
	
	if is_open:
		sprite.texture = preload("res://Assets/photos/FLVZ3724.JPG")
		collision.disabled = true
		
	else:
		sprite.texture = preload("res://Assets/photos/RPNA6042.JPG")
		collision.disabled = false
		label.visible = false

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		label.visible = true
		if is_open && player_in_range:
			label.visible = false
		elif !is_open:
			label.visible = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		label.visible = false
