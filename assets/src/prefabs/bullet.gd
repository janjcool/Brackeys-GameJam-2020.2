extends RigidBody2D

var explosion = preload("res://assets/src/prefabs/AnimationBulletFinalImpact.tscn")

func _on_bullet_body_entered(body: Node) -> void:
	if not body.is_in_group("Player"):
		var ExplosionInstance = explosion.instance()
		ExplosionInstance.position = get_global_position()
		get_tree().get_root().add_child(ExplosionInstance)
		queue_free()
	yield(get_tree().create_timer(10), "timeout")
	queue_free()
