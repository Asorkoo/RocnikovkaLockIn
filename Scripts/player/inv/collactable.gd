extends Area2D

@export var itemRes: InventoryItem

func collect(inventory: Inventory):
	inventory.insert_into_inventory(itemRes)
	queue_free()
