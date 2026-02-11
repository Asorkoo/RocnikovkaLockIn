extends Node2D

@onready var collision = $StaticBody2D/CollisionShape2D
@onready var anim = $AnimationPlayer

var is_open = false

func interact():
	is_open = !is_open

	if is_open:
		anim.play("open")
		collision.set_deferred("disabled", true)
	else:
		anim.play("close")
		collision.set_deferred("disabled", false)
