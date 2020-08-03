extends RigidBody2D

var CurrentGun
var AnimationSprites
var Damage
var BulletType
var BulletSize
var BulletLifeTime
var explosion = preload("res://assets/src/prefabs/Bullets/AnimationBulletFinalImpact.tscn")

func _ready() -> void:
	CurrentGun = get_tree().root.get_child(0).get_node("Player").get_node("GunPos").CurrentGun
	AnimationSprites = get_tree().root.get_child(0).get_node("Player").get_node("GunPos").AnimationSprites
	
	if BulletType == "Gaint":
		var NormalBulletSprite = get_node("NormalBullet")
		var BigBulletSprite = get_node("BigBullet")
		var BulletCollisionShape = get_node("CollisionShape2D")
		
		NormalBulletSprite.hide()
		BigBulletSprite.show()
		BulletCollisionShape.set_scale(Vector2(3, 4))
	else:
		var NormalBulletSprite = get_node("NormalBullet")
		var BulletCollisionShape = get_node("CollisionShape2D")
		
		NormalBulletSprite.set_scale(NormalBulletSprite.get_scale()*BulletSize)
		BulletCollisionShape.set_scale(BulletCollisionShape.get_scale()*BulletSize)
	
	yield(get_tree().create_timer(BulletLifeTime), "timeout")
	queue_free()

func _on_bullet_body_entered(body: Node) -> void:
	if body.is_in_group("Enemie"):
		var ExplosionInstance = explosion.instance()
		ExplosionInstance.position = get_global_position()
		get_tree().get_root().add_child(ExplosionInstance)
		body.health = body.health-Damage
		
		queue_free()
	elif not body.is_in_group("Player"):
		var ExplosionInstance = explosion.instance()
		ExplosionInstance.position = get_global_position()
		get_tree().get_root().add_child(ExplosionInstance)
		queue_free()
