extends CharacterBody2D

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
