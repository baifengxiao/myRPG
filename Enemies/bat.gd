extends CharacterBody2D

var knockback = Vector2.ZERO

func _physics_process(delta):
	knockback=knockback.move_toward(Vector2.ZERO,200*delta)
	velocity = knockback
	move_and_slide()
	#knockback=velocity
	
func _on_hurtbox_area_entered(area):
	
	knockback = area.knockback_vector *120
