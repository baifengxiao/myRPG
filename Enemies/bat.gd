extends CharacterBody2D

const  EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

var knockback = Vector2.ZERO

@onready var stats = $Stats

#func _ready():

func _physics_process(delta):
	knockback=knockback.move_toward(Vector2.ZERO,200*delta)
	velocity = knockback
	move_and_slide()
	#knockback=velocity
	
func _on_hurtbox_area_entered(area):
	stats.health -=area.damage
	knockback = area.knockback_vector *120


func _on_stats_no_health():
	queue_free()
	var enemyDeathEffect=EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position=global_position
	
