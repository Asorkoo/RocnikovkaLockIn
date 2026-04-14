extends CharacterBody2D

@export var movement_speed: float = 180
@export var boost_speed: float = 50
@export var boost_time: float = 3.0
@export var max_health: int = 3
@export var player_knock_strength: float = 250
@onready var inventory: Inventory = load("res://inventory/player_inventory.tres")
@onready var sprite = %sprite


@onready var hearts = [
	$"../CanvasLayer/TextureRect",
	$"../CanvasLayer/TextureRect2",
	$"../CanvasLayer/TextureRect3"
]

var character_direction : Vector2
var boost_active := false
var health: int = 3
var player_knock_velocity: Vector2 = Vector2.ZERO
var spawn_position: Vector2

func update_hearts():
	for i in range(hearts.size()):
		hearts[i].visible = i < health

func take_damage(from_position: Vector2):
	var knock_direction = (global_position - from_position).normalized()
	player_knock_velocity = knock_direction * player_knock_strength

	if health <= 0:
		return
	health -= 1
	update_hearts()
	
	if health <= 0:
		die()
		
func die():
	print("respawning..")
	health = max_health
	update_hearts()
	global_position = spawn_position
	velocity = Vector2.ZERO

func _physics_process(_delta):
	character_direction.x = Input.get_axis("move_left", "move_right")
	character_direction.y = Input.get_axis("move_up", "move_down")
	character_direction = character_direction.normalized()
	
	if character_direction.x > 0: sprite.flip_h = false
	elif character_direction.x < 0: sprite.flip_h = true
	
	if character_direction:
		velocity = character_direction * movement_speed
		if sprite.animation != "Walking":
			sprite.play("Walking")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		if sprite.animation != "Idle": 
			sprite.play("Idle")
	
	velocity += player_knock_velocity
	player_knock_velocity = player_knock_velocity.move_toward(Vector2.ZERO, 600 * _delta)
	
	move_and_slide()

func _on_area_2d_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory, self)
		
func _ready():
	print(inventory)
	health = max_health
	update_hearts()
	spawn_position = global_position
	
func speedboost_apply():
	if boost_active: return
	
	boost_active = true
	movement_speed += boost_speed
	
	await get_tree().create_timer(boost_time).timeout
	movement_speed -= boost_speed
	boost_active = false
	
func add_to_inventory(item: InventoryItem):
	if inventory and inventory.has_method("collect"):
		# Assuming your Inventory resource has a function called 'insert'
		inventory.collect(item)
	else:
		# If you don't have an 'insert' function, we'll manually add it
		# depending on how your Inventory resource is structured.
		print("Item received, but Inventory resource needs an insert function!")
