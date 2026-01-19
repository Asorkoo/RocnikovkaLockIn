extends CharacterBody2D

#MOVEMENT

@export var movement_speed: float = 50
var character_direction : Vector2

func _physics_process(_delta):
	character_direction.x = Input.get_axis("move_left", "move_right")
	character_direction.y = Input.get_axis("move_up", "move_down")
	character_direction = character_direction.normalized()
	
	if character_direction.x > 0: %sprite.flip_h = false
	elif character_direction.x < 0: %sprite.flip_h = true
	
	if character_direction:
		velocity = character_direction * movement_speed
		if %sprite.animation != "Walking": %sprite.animation = "Walking"
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		if %sprite.animation != "Idle": %sprite.animation = "Idle"
		
	move_and_slide()

#INTERACTION

var nearby_interactables: Array = []

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.has_method("interact"):
		nearby_interactables.append(body)

func _on_body_exited(body):
	nearby_interactables.erase(body)

func _input(event):
	if event.is_action_pressed("interact"):
		interact_with_closest()

func interact_with_closest():
	if nearby_interactables.is_empty():
		return

	var closest = nearby_interactables[0]
	var closest_dist = global_position.distance_to(closest.global_position)

	for obj in nearby_interactables:
		var dist = global_position.distance_to(obj.global_position)
		if dist < closest_dist:
			closest = obj
			closest_dist = dist

	closest.interact()
