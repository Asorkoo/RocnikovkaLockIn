extends CharacterBody2D

@export var speed: float = 120
@export var detection_radius: float = 600.0
@onready var sprite = %sprite
@onready var navigation: NavigationAgent2D = $NavigationAgent2D
@export var path_calc: float = 0.5
@export var attack_cooldown: float = 3.0

var can_attack := true
var player: Node2D
var path_calc_time := 0.0

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player == null:
		return
	
	var distance = global_position.distance_to(player.global_position)
	
	if distance <= detection_radius:
		path_calc_time -= delta
		if path_calc_time <= 0.0:
			navigation.target_position = player.global_position
			path_calc_time = path_calc
		
		if not navigation.is_navigation_finished():
			var next_hop = navigation.get_next_path_position()
			var direction = (next_hop - global_position).normalized()
		
			velocity = direction * speed
			if direction.x > 0:
				sprite.flip_h = false
			elif direction.x < 0:
				sprite.flip_h = true
		
			if sprite.animation != "Walking":
				sprite.play("Walking")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		
		if sprite.animation != "Idle":
			sprite.play("Idle")
	
	move_and_slide()

	
func start_cooldown():
	can_attack = false
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not can_attack:
		return
	
	if player == null:
		return
	
	var distance = global_position.distance_to(player.global_position)
	if distance > detection_radius:
		return
	
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(global_position)
			start_cooldown()
			
