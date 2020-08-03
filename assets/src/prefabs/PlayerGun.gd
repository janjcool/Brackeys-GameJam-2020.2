extends Position2D

export var offset = Vector2(25, 10)
export var CurrentGun = "417"
export var BulletSpeed = 1500
export var FireRate = 1
export var TotalAmountOfGuns = 5
export var RotationOffset = -0.2
export var OriginalFirePointPos = Vector2(50, 10)
export var GunReloadTime = 1.7

var GunTimer
var PlayerPos
var GunPos
var CurrentGunNode
var PrevouiseGun = CurrentGun
var CurrentGunID
var CanFire = true
var bullet = preload("res://assets/src/prefabs/bullet.tscn")
var PathToGuns = "../GunPos/GunSprites/"
var AnimationSprites = {
	"417": {
		"Animation time": 1.00,
		"NodePath": str(PathToGuns) + "417",
		"FireRate": FireRate*1.0,
		"ItemID": 0,
		"BulletSize": Vector2(0.8, 0.8),
		"BulletSpeed": 2000,
		"BulletLifeTime": 30,
		"BulletDamage": 15,
		"GotGun": true,
		"FirePoint": Vector2(20, -8),
		"MagazinSize": 10,
		"RunTimeMagazinSize": 10
		},
	"AWP": {
		"Animation time": 0.30,
		"NodePath": str(PathToGuns) + "AWP",
		"FireRate": FireRate*1.2,
		"ItemID": 1,
		"BulletSize": Vector2(0.8, 0.8),
		"BulletSpeed": 2500,
		"BulletLifeTime": 30,
		"BulletDamage": 15,
		"GotGun": false,
		"FirePoint": Vector2(20, -7),
		"MagazinSize": 7,
		"RunTimeMagazinSize": 7
		},
	"DesertEagle": {
		"Animation time": 0.30,
		"NodePath": str(PathToGuns) + "DesertEagle",
		"FireRate": FireRate*0.5,
		"ItemID": 2,
		"BulletSize": Vector2(0.5, 0.5),
		"BulletSpeed": 1000,
		"BulletLifeTime": 20,
		"BulletDamage": 15,
		"GotGun": true,
		"FirePoint": Vector2(0, -10),
		"MagazinSize": 10,
		"RunTimeMagazinSize": 10
		},
	"FAMAS": {
		"Animation time": 0.50,
		"NodePath": str(PathToGuns) + "FAMAS",
		"FireRate": FireRate*0.2,
		"ItemID": 3,
		"BulletSize": Vector2(0.8, 0.8),
		"BulletSpeed": 1000,
		"BulletLifeTime": 25,
		"BulletDamage": 7,
		"GotGun": false,
		"FirePoint": Vector2(15, -5),
		"MagazinSize": 50,
		"RunTimeMagazinSize": 50
		},
	"P90": {
		"Animation time": 0.45,
		"NodePath": str(PathToGuns) + "P90",
		"FireRate": FireRate*0.2,
		"ItemID": 4,
		"BulletSize": Vector2(0.8, 0.8),
		"BulletSpeed": 1000,
		"BulletLifeTime": 25,
		"BulletDamage": 5,
		"GotGun": false,
		"FirePoint": Vector2(15, -5),
		"MagazinSize": 70,
		"RunTimeMagazinSize": 70
		},
	"Six12": {
		"Animation time": 0.20,
		"NodePath": str(PathToGuns) + "Six12",
		"FireRate": FireRate*2,
		"ItemID": 5,
		"BulletSize": Vector2(2, 2),
		"BulletSpeed": 500,
		"BulletLifeTime": 50,
		"BulletDamage": 30,
		"GotGun": true,
		"FirePoint": Vector2(0, -5),
		"MagazinSize": 1,
		"RunTimeMagazinSize": 1
		},
	"ItemIDList": {
		0: "417",
		1: "AWP",
		2: "DesertEagle",
		3: "FAMAS",
		4: "P90",
		5: "Six12"
	},
	"Extra": {
		"GotGunChange": false
	}
}

func _ready() -> void:
	GunTimer = get_tree().create_timer(0.0)

func _process(_delta: float) -> void:
	SelectGun()
	CalculateGunPos()
	FlipSprite()
	MagazinCalculate()
	Fire()
	
	PrevouiseGun = CurrentGun

func CalculateGunPos():
	get_node("FirePoint").position = OriginalFirePointPos+AnimationSprites[CurrentGun]["FirePoint"]
	PlayerPos = get_owner().get_global_position()
	CurrentGunNode = get_node(AnimationSprites[CurrentGun]["NodePath"])
	CurrentGunNode.show()
	if not PrevouiseGun == CurrentGun:
		get_node(AnimationSprites[PrevouiseGun]["NodePath"]).hide()
	
	look_at(get_global_mouse_position())
	CurrentGunNode.set_global_position(get_global_position()-offset)

func ReloadManual():
	if Input.is_action_just_pressed("ReloadGun"):
		print("ok")
		ReloadGun()

func ReloadGun():
	get_node("AnimationGun").play("GunReload")
	CanFire = false
	GunTimer = get_tree().create_timer(GunReloadTime)
	yield(GunTimer, "timeout")
	CanFire = true
	AnimationSprites[CurrentGun]["RunTimeMagazinSize"] = AnimationSprites[CurrentGun]["MagazinSize"]

func MagazinCalculate():
	if AnimationSprites[CurrentGun]["RunTimeMagazinSize"] == 0:
		ReloadGun()

func Fire():
	if Input.is_action_pressed("fire") and CanFire and GunTimer.time_left <= 0.0:
		var bullet_instance = bullet.instance()
		bullet_instance.position = get_node("FirePoint").get_global_position()
		bullet_instance.rotation = get_global_rotation()+3
		bullet_instance.apply_impulse(Vector2(), Vector2(AnimationSprites[CurrentGun]["BulletSpeed"], 0).rotated(rotation))
		get_tree().get_root().add_child(bullet_instance)
		get_node("AnimationGun").play("Shoot" + CurrentGun)
		AnimationSprites[CurrentGun]["RunTimeMagazinSize"] -= 1
		CanFire = false
		print(AnimationSprites[CurrentGun]["FireRate"])
		GunTimer = get_tree().create_timer(AnimationSprites[CurrentGun]["FireRate"])
		yield(GunTimer, "timeout")
		CanFire = true

func FlipSprite():
	if get_global_rotation() > -1.5 and get_global_rotation() < 1.5:
		CurrentGunNode.set_flip_v(true)
		CurrentGunNode.set_global_rotation(get_global_rotation()-3+RotationOffset)
	else:
		CurrentGunNode.set_flip_v(false)
		CurrentGunNode.set_global_rotation(get_global_rotation()-3)

func SelectGun():
	if Input.is_action_just_pressed("PreviousEquipe") or Input.is_action_just_released("ScrollUp"):
		print("previous gun")
		CurrentGunID = AnimationSprites[CurrentGun]["ItemID"]
			
		var FindCorrect = true
		var index = 0
		while FindCorrect:
			index += 1
			if CurrentGunID-index == -1:
				CurrentGunID = TotalAmountOfGuns+1
			if AnimationSprites[AnimationSprites["ItemIDList"][CurrentGunID-index]]["GotGun"] == true:
				CurrentGunID = CurrentGunID-index
				FindCorrect = false

		CurrentGun = AnimationSprites["ItemIDList"][CurrentGunID]
		CanFire = true
	elif Input.is_action_just_pressed("NextEquipe") or Input.is_action_just_released("ScrollDown"):
		print("next gun")
		CurrentGunID = AnimationSprites[CurrentGun]["ItemID"]
		
		var FindCorrect = true
		var index = 0
		while FindCorrect:
			index += 1
			if CurrentGunID+index == TotalAmountOfGuns+1:
				CurrentGunID = -1
				print(CurrentGunID)
			if AnimationSprites[AnimationSprites["ItemIDList"][CurrentGunID+index]]["GotGun"] == true:
				CurrentGunID = CurrentGunID+index
				FindCorrect = false
		
		CurrentGun = AnimationSprites["ItemIDList"][CurrentGunID]
		CanFire = true
