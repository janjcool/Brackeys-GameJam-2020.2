extends KinematicBody2D

export var speed = Vector2(300.0, 1000.0)
export var gravity = 3000.0 
export var Health = 100

var velocity = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	var animation: = "PlayerJump"
	var is_jump_interrupted = Input.is_action_just_released("jump") and velocity.y < 0.0
	var direction: = get_direction()
	
	velocity = calculate_move_velocity(velocity, direction, speed, is_jump_interrupted)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	animation = AnimationChooser(animation)
	get_node("AnimationPlayer").play(animation)
	
	Die()

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)
	
func Die():
	if Health <= 0:
		queue_free()

func AnimationChooser(animation):
	if Input.is_action_just_released("Duck"):
		get_node("CollisionShape2D").scale = Vector2(1, 1)
		get_node("CollisionShape2D").position = Vector2(0, 2)
	elif Input.is_action_pressed("Duck"):
		animation = "PlayerDuck"
		get_node("CollisionShape2D").scale = Vector2(0, 0.675)
		get_node("CollisionShape2D").position = Vector2(0, 20)
	elif not velocity.y == 0:
		#print(velocity.y)
		animation = "PlayerJump"
	elif not Input.get_action_strength("jump") == 0 and not is_on_floor():
		animation = "PlayerJump"
	elif velocity.x > 0:
		animation = "PlayerRunRight"
	elif velocity.x < 0:
		animation = "PlayerRunLeft"
	else:
		animation = "PlayerIdle"
		
	return animation
	
func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var new_velocity: = linear_velocity
	new_velocity.x = speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		new_velocity.y = gravity * 0.0
	return new_velocity
