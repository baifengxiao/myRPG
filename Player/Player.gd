extends CharacterBody2D

@export var MAX_SPEED = 80
@export var ACCELERATION = 500
@export var ROLL_SPEED=125
@export var FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state=MOVE
var roll_vector=Vector2.DOWN
var stats =PlayerStats

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var swordHitbox = $HitboxPivot/SwordHitBox
@onready var hurtbox = $Hurtbox


func _ready():
	stats.connect("no_health",queue_free)
	animationTree.active=true
	
	swordHitbox.knockback_vector=roll_vector

func _physics_process(delta):
	
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
			
func move_state(delta):
	
	var input_vector = Vector2.ZERO
	input_vector.x=Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y=Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector=input_vector
		swordHitbox.knockback_vector=input_vector
		animationTree.set("parameters/Idle/blend_position",input_vector) 
		animationTree.set("parameters/Run/blend_position",input_vector)
		#为什么不放在攻击动作里面
		animationTree.set("parameters/Attack/blend_position",input_vector)
		animationTree.set("parameters/Roll/blend_position",input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED ,ACCELERATION * delta) 
	else :
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO,FRICTION * delta)

	
	move()
	
	if Input.is_action_just_pressed("roll"):
		state=ROLL
	
	if Input.is_action_just_pressed("attack"):
		state=ATTACK
		
func roll_state(delta):
	velocity=roll_vector*ROLL_SPEED
	animationState.travel("Roll")
	move()
		
func attack_state(delta):
	velocity=Vector2.ZERO 
	animationState.travel("Attack")
	#travel功能:找最近的路径播放这个动画
	
func move():
		
	move_and_slide()
	
func roll_animation_finished():
	velocity=velocity/2
	state = MOVE
	
func attack_animation_finished():
	state  = MOVE


func _on_hurtbox_area_entered(area):
	
	stats.health -=1
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
