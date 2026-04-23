extends Node2D

@export var req_item: InventoryItem
@onready var inventory: Inventory = load("res://inventory/player_inventory.tres")
@onready var label = $Label
@onready var label2 = $Label2
@onready var anim = $AnimationPlayer
@onready var bus_tutudu: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var bus_motor: AudioStreamPlayer2D = $AudioStreamPlayer2D2

var can_interact = false
var departed = false

func has_bus_key() -> bool:
	for item in inventory.items:
		if item == req_item:
			return true
	return false

func _ready():
	label.hide()
	label2.hide()

func _process(_delta):
	if can_interact and not departed:
		if Input.is_action_just_pressed("interact"):
			drive_away()
	else:
		label2.hide()

func drive_away():
	label.hide()
	if !has_bus_key():
		label2.show()
		return
	
	departed = true
	label2.hide()
	bus_motor.play()
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_physics_process(false)
		player.hide()
		
	print("Drive away started!")
	$Camera2D.make_current()
	bus_tutudu.play()
	anim.play("drive_away")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://Scenes/end_scene.tscn")

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		label.show()
		can_interact = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		can_interact = false
		label.hide()
		label2.hide()
