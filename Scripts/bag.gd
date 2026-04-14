extends StaticBody2D

@export var contents: Array[InventoryItem] = []
@onready var range: Area2D = $Area2D
var player_in_range: bool = false
var player_node: Node2D = null

func _ready() -> void:
	range.body_entered.connect(_on_body_entered)
	range.body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		empty_bag()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		player_node = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		player_node = null

func empty_bag() -> void:
	if contents.is_empty():
		return
		
	for item in contents:
		if player_node.has_method("add_to_inventory"):
			player_node.add_to_inventory(item)
			print("Passed ", item.name, " to Player logic.")
		else:
			player_node.inventory.collect(item)
			
	contents.clear()
	queue_free()
