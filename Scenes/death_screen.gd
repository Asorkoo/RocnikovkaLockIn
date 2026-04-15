extends CanvasLayer

@onready var black_screen = $ColorRect

func _ready():
	hide()
	black_screen.modulate.a = 0

func show_death_screen():
	show()
	var tween = create_tween()
	tween.tween_property(black_screen, "modulate:a", 1.0, 1.0) 

func hide_death_screen():
	var tween = create_tween()
	tween.tween_property(black_screen, "modulate:a", 0.0, 1.0) 
	await tween.finished
	hide()
