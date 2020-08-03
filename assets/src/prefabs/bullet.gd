extends RigidBody2D

var explosion = preload("res://assets/src/prefabs/AnimationBulletFinalImpact.tscn")
var CurrentGun
var AnimationSprites

func _ready() -> void:
	CurrentGun = get_tree().root.get_child(0).get_node("Player").get_node("GunPos").CurrentGun
	AnimationSprites = get_tree().root.get_child(0).get_node("Player").get_node("GunPos").AnimationSprites
	
	if CurrentGun == "Six12":
		var NormalBulletSprite = get_node("NormalBullet")
		var BigBulletSprite = get_node("BigBullet")
		var BulletCollisionShape = get_node("CollisionShape2D")
		
		NormalBulletSprite.hide()
		BigBulletSprite.show()
		BulletCollisionShape.set_scale(Vector2(3, 4))
	else:
		var NormalBulletSprite = get_node("NormalBullet")
		var BulletCollisionShape = get_node("CollisionShape2D")
		
		NormalBulletSprite.set_scale(NormalBulletSprite.get_scale()*AnimationSprites[CurrentGun]["BulletSize"])
		BulletCollisionShape.set_scale(BulletCollisionShape.get_scale()*AnimationSprites[CurrentGun]["BulletSize"])

func _on_bullet_body_entered(body: Node) -> void:
	if not body.is_in_group("Player"):
		var ExplosionInstance = explosion.instance()
		ExplosionInstance.position = get_global_position()
		get_tree().get_root().add_child(ExplosionInstance)
		queue_free()
	yield(get_tree().create_timer(AnimationSprites[CurrentGun]["BulletLifeTime"]), "timeout")
	queue_free()
