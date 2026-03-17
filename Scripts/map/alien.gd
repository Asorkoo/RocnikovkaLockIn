extends CharacterBody2D

@export var speed: float = 80
@export var detection_radius: float = 600.0
@onready var sprite = %sprite

var player: Node2D


func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(_delta):
	if player == null:
		return
	
	var distance = global_position.distance_to(player.global_position)
	var direction = (player.global_position - global_position).normalized()
	
	if distance <= detection_radius:
		velocity = direction * speed
		
		if direction.x > 0:
			sprite.flip_h = false
		elif direction.x < 0:
			sprite.flip_h = true
		
		if sprite.animation != "Walking":
			sprite.animation = "Walking"
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		
		if sprite.animation != "Idle":
			sprite.animation = "Idle"
	
	move_and_slide()
