extends RigidBody2D

var CurrentGun
var GunDict
var Damage
var BulletSize
var BulletLifeTime
var explosion = preload("res://assets/src/prefabs/Bullets/AnimationBulletFinalImpact.tscn")

func _ready() -> void:
	GunDict = get_tree().root.get_node("LevelTemplate").get_node("Player").GunDict
	
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
