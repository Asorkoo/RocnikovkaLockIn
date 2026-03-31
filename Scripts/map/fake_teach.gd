extends CharacterBody2D

@export var speed: float = 120
@export var detection_radius: float = 600.0
@onready var sprite = %sprite

var player: Node2D
var chase: float = 0.0

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
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
		
		chase += delta
		
		if chase < 2.0:
			if sprite.animation != "Walking":
				sprite.play("Walking")
		else:
			if sprite.animation != "Walking_Alien":
				sprite.play("Walking_Alien")
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		chase = 0.0
		
		if sprite.animation != "Idle":
			sprite.play("Idle")
	
	move_and_slide()
