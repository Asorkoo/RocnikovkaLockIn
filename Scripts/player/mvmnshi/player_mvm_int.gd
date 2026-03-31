extends CharacterBody2D

@export var movement_speed: float = 180
@export var boost_speed: float = 50
@export var boost_time: float = 3.0
@onready var inventory: Inventory = load("res://inventory/player_inventory.tres")
@onready var sprite = %sprite

var character_direction : Vector2
var boost_active := false

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
		
	move_and_slide()

func _on_area_2d_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory, self)
		
func _ready():
	print(inventory)
	
func speedboost_apply():
	if boost_active: return
	
	boost_active = true
	movement_speed += boost_speed
	
	await get_tree().create_timer(boost_time).timeout
	movement_speed -= boost_speed
	boost_active = false
	
