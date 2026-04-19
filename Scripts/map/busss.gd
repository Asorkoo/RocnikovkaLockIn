extends Node2D

@onready var label = $Label
@onready var anim = $AnimationPlayer

var can_interact = false
var departed = false

func _ready():
	label.hide()

func _process(_delta):
	if can_interact and not departed:
		if Input.is_action_just_pressed("interact"): 
			drive_away()

func drive_away():
	departed = true
	label.hide()
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_physics_process(false)
		player.hide()
		
	$Camera2D.make_current()
	anim.play("drive_away")
	await anim.animation_finished
	get_tree().quit()
	# get_tree().change_scene_to_file("konec hry")

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		can_interact = true
		label.show()

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		can_interact = false
		label.hide()
