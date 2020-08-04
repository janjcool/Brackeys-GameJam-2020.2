extends Position2D

export var offset = Vector2(25, 10)
export var CurrentGun = "417"
export var BulletSpeed = 1500
export var FireRate = 1
export var TotalAmountOfGuns = 5
export var RotationOffset = -0.2
export var OriginalFirePointPos = Vector2(50, 10)
export var GunReloadTime = 1.4

var GunTimer
var PlayerPos
var GunPos
var CanFire = true
var bullet = preload("res://assets/src/prefabs/Bullets/bullet.tscn")
var GunDict = {
	"Animation time": 1.00,
	"FireRate": FireRate*1.0,
	"BulletSize": Vector2(0.8, 0.8),
	"BulletSpeed": 2000,
	"BulletLifeTime": 30,
	"BulletDamage": 15,
	"FirePoint": Vector2(20, -8),
	"MagazinSize": 10,
	"RunTimeMagazinSize": 10,
	"BulletType": "Normal"
}

func _ready() -> void:
	GunTimer = get_tree().create_timer(0.0)

func _process(_delta: float) -> void:
	PlayerPos = get_owner().get_global_position()
	
	MagazinCalculate()
	ReloadManual()
	Fire()

func ReloadManual():
	if Input.is_action_just_pressed("ReloadGun"):
		ReloadGun()

func ReloadGun():
	SoundSetPos()
	get_node("AnimationGun").play("ReloadGun")
	CanFire = false
	GunTimer = get_tree().create_timer(GunReloadTime)
	yield(GunTimer, "timeout")
	CanFire = true
	GunDict["RunTimeMagazinSize"] = GunDict["MagazinSize"]

func MagazinCalculate():
	if GunDict["RunTimeMagazinSize"] == 0:
		ReloadGun()

func Fire():
	if Input.is_action_pressed("fire") and CanFire and GunTimer.time_left <= 0.0:
		var BulletInstance = bullet.instance()
		BulletInstance.position = get_node("FirePoint").get_global_position()
		BulletInstance.rotation = get_global_rotation()#+3
		BulletInstance.BulletSize = GunDict["BulletSize"]
		BulletInstance.BulletLifeTime = GunDict["BulletLifeTime"]
		BulletInstance.Damage = GunDict["BulletDamage"]
		BulletInstance.apply_impulse(Vector2(), Vector2(GunDict["BulletSpeed"], 0).rotated(rotation))
		get_tree().get_root().add_child(BulletInstance)
		SoundSetPos()
		GunDict["RunTimeMagazinSize"] -= 1
		CanFire = false
		GunTimer = get_tree().create_timer(GunDict["FireRate"])
		yield(GunTimer, "timeout")
		CanFire = true

func SoundSetPos():
	get_node("ReloadSound").position = get_global_position()

"""
func FlipSprite():
	if get_global_rotation() > -1.5 and get_global_rotation() < 1.5:
		CurrentGunNode.set_flip_v(true)
		CurrentGunNode.set_global_rotation(get_global_rotation()-3+RotationOffset)
	else:
		CurrentGunNode.set_flip_v(false)
		CurrentGunNode.set_global_rotation(get_global_rotation()-3)
"""
