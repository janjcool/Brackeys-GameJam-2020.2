extends RigidBody2D

export var NextLevel = ""



func _on_NextLevelBox_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		get_tree().change_scene(NextLevel)
