extends CharacterBody2D

@export var speed: float = 120
@export var detection_radius: float = 600.0
@export var path_calc: float = 0.5
@export var attack_cooldown: float = 1.5

@onready var sprite = %sprite
@onready var navigation: NavigationAgent2D = $NavigationAgent2D

var can_attack := true
var player: Node2D
var path_calc_time := 0.0
var player_in_range: Node2D = null 
var spawn_position: Vector2

func _ready():
	player = get_tree().get_first_node_in_group("player")
	spawn_position = global_position
	add_to_group("enemies")
	
func reset_scene():
	global_position = spawn_position
	velocity = Vector2.ZERO
	path_calc_time = 0.0
	
func _physics_process(delta):
	if player == null:
		return
	
	movement(delta)
	attack() 

func movement(delta: float):
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
			sprite.flip_h = direction.x < 0
		
			if sprite.animation != "Walking":
				sprite.play("Walking")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		if sprite.animation != "Idle":
			sprite.play("Idle")
	
	move_and_slide()

func attack():
	if can_attack and player_in_range:
		if player_in_range.has_method("take_damage"):
			player_in_range.take_damage(global_position)
			start_cooldown()

func start_cooldown():
	can_attack = false
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = null
