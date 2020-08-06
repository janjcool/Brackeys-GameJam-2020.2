extends Node2D

export var MaxSeeDistance = 1100
export var Damage = 30
export var health = 30
export var BulletSpeed = 1500
export var FireRate = 1.5
export var flip = false
export var BulletLifeTime = 15

var PlayerNode
var GunTimer
var PlayerInRange = false
var CanFire = true
var bullet = preload("res://assets/src/prefabs/Bullets/BulletEnemieRPG.tscn")

func _ready() -> void:
	PlayerNode = get_tree().root.get_child(2).get_node("Player")
	GunTimer = get_tree().create_timer(FireRate)
	
	if flip:
		BulletSpeed = BulletSpeed*-1

func _process(delta: float) -> void:
	Die()
	LookForPlayer()
	if PlayerInRange == true:
		Shoot()

func LookForPlayer():
	if PlayerNode.position.x-position.x < MaxSeeDistance and PlayerNode.position.x-position.x > MaxSeeDistance*-1:
		PlayerInRange = true
	else:
		PlayerInRange = false

func Die():
	if health <= 0:
		get_node("CollisionShape2D").set_disabled(true)
		get_node("Animation").play("Die")
		GunTimer = get_tree().create_timer(2)
		yield(GunTimer, "timeout")
		queue_free()

func Shoot():
	if CanFire == true and GunTimer.time_left <= 0.0:
		var BulletInstance = bullet.instance()
		BulletInstance.position = get_node("FirePoint").get_global_position()
		BulletInstance.rotation = get_global_rotation()#+3
		BulletInstance.Damage = Damage
		BulletInstance.BulletLifeTime = BulletLifeTime
		BulletInstance.apply_impulse(Vector2(), Vector2(BulletSpeed, 0).rotated(rotation))
		get_tree().get_root().add_child(BulletInstance)
		
		get_node("Animation").play("Shoot")
		CanFire = false
		GunTimer = get_tree().create_timer(FireRate)
		yield(GunTimer, "timeout")
		CanFire = true
