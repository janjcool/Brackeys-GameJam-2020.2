extends KinematicBody2D

export var speed = Vector2(300.0, 1000.0)
export var gravity = 3000.0 
export var DuckFirePointOffset = Vector2(0, 14)
export var Health = 1
export var offset = Vector2(25, 10)
export var CurrentGun = "417"
export var BulletSpeed = 1500
export var FireRate = 1
export var TotalAmountOfGuns = 5
export var RotationOffset = -0.2
export var OriginalFirePointPos = Vector2(38, 0)
export var GunReloadTime = 1
export var Lives = 3
export var FirePointOffset = Vector2(120, 0)
export var ShootAudioFile = "res://assets/sound/q009-sounds/q009/pistol.wav"
export var bullet = preload("res://assets/src/prefabs/Bullets/bullet.tscn")
export var ShootSound = preload("res://assets/src/prefabs/Bullets/PlayerShootAudio.tscn")

var StartLives = Lives
var StartPosition
var velocity = Vector2.ZERO
var IsDying = false
var GunTimer
var PlayerPos
var GunPos
var AnimationIsLeft = false
var SoundPlayer
var Shoot
var direction = Vector2()
var Reloading = false
var AnimationTimer
var CanFire = true
var GunDict = {
	"Animation time": 1.00,
	"FireRate": FireRate*0.2,
	"BulletSize": Vector2(0.8, 0.8),
	"BulletSpeed": 2000,
	"BulletLifeTime": 0.5,
	"BulletDamage": 15,
	"FirePoint": Vector2(20, -8),
	"MagazinSize": 50,
	"RunTimeMagazinSize": 50,
	"BulletType": "Normal"
}

func _ready() -> void:
	GunTimer = get_tree().create_timer(0.0)
	AnimationTimer = get_tree().create_timer(0.0)
	StartPosition = position
	

func _process(_delta: float) -> void:
	PlayerPos = get_global_position()
	var animation
	
	MagazinCalculate()
	ReloadManual()
	Fire()
	Die()
	
	animation = AnimationChooser(animation)
	get_node("AnimationPlayer").play(animation)

func _physics_process(_delta: float) -> void:
	var is_jump_interrupted = Input.is_action_just_released("jump") and velocity.y < 0.0
	direction = get_direction()
	
	velocity = calculate_move_velocity(velocity, is_jump_interrupted)
	velocity = Vector2(0, velocity.y) if IsDying == true else velocity
	velocity.x = 0 if Input.is_action_pressed("Duck") and is_on_floor() else velocity.x
	velocity.y = 0 if Input.is_action_pressed("Duck") and velocity.y < 0 else velocity.y
	velocity = move_and_slide(velocity, Vector2.UP)

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)
	
func Die():
	if Health <= 0 and IsDying == false:
		if Lives <= 0 and IsDying == false:
			print("Die")
			IsDying = true
	
			GunTimer = get_tree().create_timer(3.0)
			yield(GunTimer, "timeout")
		
			var error_code = get_tree().reload_current_scene()
			if error_code != 0:
				print("ERROR: ", error_code)
		if IsDying == false:
			print("-1 live")
			Health = 1
			Lives -= 1
			IsDying = true
			GunTimer = get_tree().create_timer(1.0)
			yield(GunTimer, "timeout")
			IsDying = false
			position = StartPosition
			Health = 1

func AnimationChooser(animation):
	if Input.is_action_just_pressed("Duck"):
		get_node("CollisionShape2D").scale.y = 0.8
		get_node("PlayerSprite").position = Vector2(0, -20)
		get_node("GunPos/FirePoint").position = Vector2(38, 5)
	elif Input.is_action_just_released("Duck"):
		get_node("CollisionShape2D").scale.y = 1
		get_node("PlayerSprite").position = Vector2(0, -11)
		get_node("GunPos/FirePoint").position = Vector2(38, 0)
	
	if IsDying == true:
		animation = "DieRight"
	elif Input.is_action_pressed("Duck") and direction.x == 1:
		AnimationIsLeft = false
		if Shoot == true or Input.is_action_pressed("fire") and Reloading == false:
			animation = "DuckShootRight"
			Shoot = false
		else:
			animation = "DuckRight"
	elif Input.is_action_pressed("Duck") and direction.x == -1:
		AnimationIsLeft = true
		if Shoot == true or Input.is_action_pressed("fire") and Reloading == false:
			animation = "DuckShootLeft"
			Shoot = false
		else:
			animation = "DuckLeft"
	elif Input.is_action_pressed("Duck"):
		if AnimationIsLeft == false:
			if Shoot == true or Input.is_action_pressed("fire") and Reloading == false:
				animation = "DuckShootRight"
				Shoot = false
			else:
				animation = "DuckRight"
		else:
			if Shoot == true or Input.is_action_pressed("fire") and Reloading == false:
				animation = "DuckShootLeft"
				Shoot = false
			else:
				animation = "DuckLeft"
	elif not is_on_floor() and direction.x == 1:
		AnimationIsLeft = false
		if Shoot == true or Input.is_action_pressed("fire") and Reloading == false:
			animation = "JumpRightAndShootRight"
			Shoot = false
		else:
			animation = "PlayerJumpRight"
	elif not is_on_floor() and direction.x == -1:
		AnimationIsLeft = true
		if Shoot == true or Input.is_action_pressed("fire") and Reloading == false:
			animation = "JumpLeftAndShootLeft"
			Shoot = false
		else:
			animation = "PlayerJumpLeft"
	elif not is_on_floor():
		if AnimationIsLeft == false:
			if Shoot == true or Input.is_action_pressed("fire") and Reloading == false:
				animation = "JumpRightAndShootRight"
				Shoot = false
			else:
				animation = "PlayerJumpRight"
		else:
			if Shoot == true or Input.is_action_pressed("fire") and Reloading == false:
				animation = "JumpLeftAndShootLeft"
				Shoot = false
			else:
				animation = "PlayerJumpLeft"
	elif direction.x == 1:
		AnimationIsLeft = false
		if Shoot == true or Input.is_action_pressed("fire") and Reloading == false or not GunTimer.time_left <= 0.0:
			animation =  "ShootRightAndRunRight"
			Shoot = false
		else:
			animation = "PlayerRunRight"
	elif direction.x == -1:
		AnimationIsLeft = true
		if Shoot == true or Input.is_action_pressed("fire") and Reloading == false or not GunTimer.time_left <= 0.0:
			animation = "ShootLeftAndRunLeft"
			Shoot = false
		else:
			animation = "PlayerRunLeft"
	else:
		if AnimationIsLeft == false:
			if Shoot == true or Input.is_action_pressed("fire") and Reloading == false:
				animation = "ShootRight"
				Shoot = false
			else:
				animation = "PlayerIdle"
		else:
			if Shoot == true or Input.is_action_pressed("fire") and Reloading == false:
				animation = "ShootLeft"
				Shoot = false
			else:
				animation = "PlayerIdleLeft"
	
	return animation
	
func calculate_move_velocity(
		linear_velocity: Vector2,
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

func ReloadManual():
	if Input.is_action_just_pressed("ReloadGun"):
		ReloadGun()

func ReloadGun():
	Reloading = true
	SoundSetPos()
	get_node("GunPos/AnimationGun").play("ReloadGun")
	CanFire = false
	GunTimer = get_tree().create_timer(GunReloadTime)
	yield(GunTimer, "timeout")
	CanFire = true
	GunDict["RunTimeMagazinSize"] = GunDict["MagazinSize"]
	Reloading = false

func MagazinCalculate():
	if GunDict["RunTimeMagazinSize"] == 0:
		ReloadGun()

func Fire():
	if Input.is_action_pressed("fire") and CanFire and GunTimer.time_left <= 0.0:
		var BulletInstance = bullet.instance()
		BulletInstance.BulletSize = GunDict["BulletSize"]
		BulletInstance.BulletLifeTime = GunDict["BulletLifeTime"]
		BulletInstance.Damage = GunDict["BulletDamage"]
		if AnimationIsLeft == false:
			BulletInstance.apply_impulse(Vector2(), Vector2(GunDict["BulletSpeed"], 0).rotated(rotation))
			if Input.is_action_pressed("Duck"):
				BulletInstance.position = get_node("GunPos/FirePoint").get_global_position()+DuckFirePointOffset
			else:
				BulletInstance.position = get_node("GunPos/FirePoint").get_global_position()
		else:
			BulletInstance.apply_impulse(Vector2(), Vector2(GunDict["BulletSpeed"]*-1, 0).rotated(rotation))
			get_node("GunPos/FirePoint").position = get_node("GunPos/FirePoint").position-FirePointOffset
			if Input.is_action_pressed("Duck"):
				BulletInstance.position = get_node("GunPos/FirePoint").get_global_position()+DuckFirePointOffset
			else:
				BulletInstance.position = get_node("GunPos/FirePoint").get_global_position()
			get_node("GunPos/FirePoint").position = OriginalFirePointPos
		get_tree().get_root().add_child(BulletInstance)
		
		var ShootSoundInstance = ShootSound.instance()
		if Input.is_action_pressed("Duck"):
			ShootSoundInstance.position = get_node("GunPos/FirePoint").get_global_position()+DuckFirePointOffset
		else:
			ShootSoundInstance.position = get_node("GunPos/FirePoint").get_global_position()
		get_tree().get_root().add_child(ShootSoundInstance)
		
		Shoot = true
		SoundSetPos()
		GunDict["RunTimeMagazinSize"] -= 1
		
		CanFire = false
		GunTimer = get_tree().create_timer(GunDict["FireRate"])
		yield(GunTimer, "timeout")
		CanFire = true

func SoundSetPos():
	get_node("GunPos/ReloadSound").position = get_global_position()
