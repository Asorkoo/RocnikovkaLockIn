extends CanvasLayer

@onready var black_screen = $ColorRect

func _ready():
	hide()

func show_death_screen():
	self.show()
	black_screen.modulate.a = 0 
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 2.0)
	
func _input(event):
	if visible and event.is_action_pressed("ui_accept"):
		Engine.time_scale = 1.0
		get_tree().reload_current_scene()
