extends Node2D

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass



func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game_scene.tscn")

func _on_secret_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game_scene.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")

func _on_what_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/what.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
