extends "res://Scripts/player/inv/collactable.gd"

@onready var eat_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

func collect(inventory: Inventory, player = null):
	eat_sound.play()
	await eat_sound.finished
	if player and player.has_method("speedboost_apply"):
		player.speedboost_apply()
	if player and player.has_method("health_regen"):
		player.health_regen()
	queue_free()
