extends RigidBody2D



func _on_NextLevelBox_body_entered(body: Node) -> void:
	print("restart")
	get_tree().reload_current_scene()
