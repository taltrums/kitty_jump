extends CharacterBody2D

class_name Player

var speed = 300.0
var gravity = 15.0
var max_fall_velocity = 1000
var viewport_size
var jump_velocity = -800
var accelerometer_speed = 130

var use_accelerometer = false
@onready var animator = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	viewport_size = get_viewport_rect().size
	var os_name = OS.get_name()
	
	if os_name == "Android":
		use_accelerometer = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if velocity.y > 0 && velocity.x < 0:
		if animator.animation != "jump_left":
			animator.play("jump_left")
	elif velocity.y < 0 && velocity.x > 0:
		if animator.animation != "jump_right":
			animator.play("jump_right")


func _physics_process(_delta):
	velocity.y += gravity
	if velocity.y > max_fall_velocity:
		velocity.y = max_fall_velocity
		
	if use_accelerometer:
		var mobile_input = Input.get_accelerometer()
		velocity.x = mobile_input.x * accelerometer_speed
	
	else:
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		
	
	move_and_slide()
	
	var margin = 20
	if global_position.x > viewport_size.x + margin:
		global_position.x = -margin
	if global_position.x < -margin:
		global_position.x = viewport_size.x + margin   
	


func jump():
	velocity.y = jump_velocity
