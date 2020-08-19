extends RigidBody2D

export var NextLevel = ""



func _on_NextLevelBox_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		var error_code = get_tree().change_scene(NextLevel)
		if error_code != 0:
			print("ERROR: ", error_code)
