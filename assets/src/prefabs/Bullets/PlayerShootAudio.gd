extends AudioStreamPlayer2D

func _on_PlayerShoot_finished() -> void:
	queue_free()
