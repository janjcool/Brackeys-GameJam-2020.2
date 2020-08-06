extends KinematicBody2D

export var Gravity = 30
export var Speed = Vector2(200, 0)
export var Floor = Vector2(0, -1)
export var DistanceMax = 80000
export var MaxWaitTime = 8
export var SeeDistance = 500
export var bullet = preload("res://assets/src/prefabs/Bullets/BulletEnemieAR.tscn")
export var Damage = 10
export var health = 20
export var BulletLifeTime = 10
export var BulletSpeed = 1500
export var FireRate = 0.8
export var debugging = false

var Direction = 1
var GameTimer
var Distance
var WaitTime
var Velocity
var DistanceCounter = 0
var NotSeeProcess = "walk"
var BussyWaiting = false
var PlayerSee = false
var PlayerPosition = Vector2()
var DistanceBetweenPlayer = 0
var PlayerDirection = "Left"
var Shooting = false
var CanFire = true
var GunTimer
var Dying = false
var FirstTimeShoot = true
var AnimationType
var AnimationTimer

func _ready():
	GameTimer = get_tree().create_timer(0.0)
	GunTimer = get_tree().create_timer(0.0)
	AnimationTimer = get_tree().create_timer(0.0)
	Distance = randi()%DistanceMax+1
	WaitTime = randi()%MaxWaitTime+1

func _process(delta: float) -> void:
	PlayerPosition = get_tree().root.get_child(2).get_node("Player").get_global_position()
	LookForPlayer()
	
	if PlayerSee == false:
		NotseeProcess()
	elif PlayerSee == true:
		SeePlayerProcess()
	
	Die()
	AnimationChooser()
	get_node("AnimationPlayer").play(AnimationType)

func _physics_process(delta: float) -> void:
	Velocity = Vector2()
	calculate_move_velocity()
	if Dying == false:
		Velocity = move_and_slide(Velocity, Floor)

func SeePlayerProcess():
	if PlayerDirection == "Right":
		Direction = 1
	else:
		Direction = -1
	
	Fire()

func Die():
	if health < 0:
		get_node("CollisionShape2D").set_disabled(true)
		Dying = true
		GunTimer = get_tree().create_timer(2)
		yield(GunTimer, "timeout")
		queue_free()

func Fire():
	if FirstTimeShoot == true:
		FirstTimeShoot = false
		CanFire = false
		GunTimer = get_tree().create_timer(0.1)
		yield(GunTimer, "timeout")
		CanFire = true
	if CanFire and GunTimer.time_left <= 0.0:
		var BulletInstance = bullet.instance()
		BulletInstance.position = get_node("Sprite/FirePoint").get_global_position()
		BulletInstance.rotation = get_global_rotation()
		BulletInstance.Damage = Damage
		BulletInstance.BulletLifeTime = BulletLifeTime
		var TempBulletSpeed = CalculateBulletSpeed()
		BulletInstance.apply_impulse(Vector2(), Vector2(TempBulletSpeed, 0).rotated(rotation))
		get_tree().get_root().add_child(BulletInstance)
		
		Shooting = true
		CanFire = false
		GunTimer = get_tree().create_timer(FireRate)
		yield(GunTimer, "timeout")
		CanFire = true

func CalculateBulletSpeed():
	var TempBulletSpeed = BulletSpeed
	if PlayerDirection == "Left": 
		TempBulletSpeed = BulletSpeed*-1
	
	return TempBulletSpeed

func NotseeProcess():
	if is_on_wall():
		Direction = Direction*-1
	
	DistanceCounter += abs(Velocity.x)
	if BussyWaiting == true:
		pass
	elif NotSeeProcess == "wait":
		BussyWaiting = true
		GameTimer = get_tree().create_timer(WaitTime)
		yield(GameTimer, "timeout")
		WaitTime = randi()%MaxWaitTime+1
		Distance = randi()%DistanceMax+1
		BussyWaiting = false
		NotSeeProcess = "walk"
	elif DistanceCounter >= Distance:
		NotSeeProcess = "wait"
		DistanceCounter = 0
		Distance = randi()%DistanceMax+1

func calculate_move_velocity():
	if not NotSeeProcess == "wait" and PlayerSee == false:
		Velocity.x = Speed.x * Direction
		
		
	Velocity.y += Gravity
	return Velocity

func AnimationChooser():
	if AnimationTimer.time_left <= 0.0:
		if Dying == true:
			AnimationType = "Die"
		elif Velocity.x == 0:
			if Shooting == false:
				if Direction == 1:
					AnimationType = "IdleRight"
				elif Direction == -1:
					AnimationType = "IdleLeft"
			else:
				Shooting = false
				
				if Direction == 1:
					AnimationType = "ShootRight"
					AnimationTimer = get_tree().create_timer(0.2)
					yield(AnimationTimer, "timeout")
				elif Direction == -1:
					AnimationType = "ShootLeft"
					AnimationTimer = get_tree().create_timer(0.2)
					yield(AnimationTimer, "timeout")
		elif Direction == 1:
			AnimationType = "RunRight"
		elif Direction == -1:
			AnimationType = "RunLeft"
		else:
			AnimationType = "IdleRight"

func LookForPlayer():
	DistanceBetweenPlayer = get_global_position().distance_to(PlayerPosition)
	
	if DistanceBetweenPlayer >= SeeDistance:
		PlayerSee = false
	else:
		PlayerSee = true
	
	if get_global_position().x-PlayerPosition.x <= 0:
		PlayerDirection = "Right"
	if get_global_position().x-PlayerPosition.x >= 0:
		PlayerDirection = "Left"
