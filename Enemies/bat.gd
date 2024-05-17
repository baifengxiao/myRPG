extends CharacterBody2D

const  EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

@export var ACCELERATION=1000
@export var MAX_SPEED=5000
@export var FRICTION=200

enum {
	IDLE,
	WANDER,
	CHASE
}

#var velocity=Vector2.ZERO
var knockback = Vector2.ZERO

var state =CHASE

@onready var sprite = $AnimatedSprite
@onready var stats = $Stats
@onready var playerDetectionZone=$PlayerDetectionZone

func _physics_process(delta):
	knockback=knockback.move_toward(Vector2.ZERO,FRICTION*delta)
	velocity = knockback
	move_and_slide()
	
	match state:
		IDLE:
			velocity=velocity.move_toward(Vector2.ZERO,FRICTION*delta)
			seek_player()
			
		WANDER:
			pass
		
		CHASE:
			var player = playerDetectionZone.player
			if player!=null:
				var direction=(player.global_position-global_position).normalized()
				velocity=velocity.move_toward(direction*MAX_SPEED,ACCELERATION*delta)
			else :
				state=IDLE
			sprite.flip_h=velocity.x<0
	move_and_slide()
		
func seek_player():
	if playerDetectionZone.can_see_player():
		state=CHASE
	
func _on_hurtbox_area_entered(area):
	stats.health -=area.damage
	knockback = area.knockback_vector *120


func _on_stats_no_health():
	queue_free()
	var enemyDeathEffect=EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position=global_position
	
