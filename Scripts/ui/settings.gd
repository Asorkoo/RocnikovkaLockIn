extends Control

@onready var volume_slider = $MarginContainer/VBoxContainer/Volume

func _ready() -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	var current_db = AudioServer.get_bus_volume_db(bus_index)
	
	volume_slider.value = db_to_linear(current_db)
	
func _on_volume_value_changed(value: float) -> void:
	var music_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_index, linear_to_db(value))
	
func _on_check_box_toggled(toggled_on: bool) -> void:
	var music_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(music_index, toggled_on)
	
	

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
