extends StaticBody2D

func interact():
	if $CollisionShape2D:
		$CollisionShape2D.disabled = true  
	visible = false                        
