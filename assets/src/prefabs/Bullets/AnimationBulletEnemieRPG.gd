extends Node2D

func _ready():
	get_node("AnimationPlayer").play("Explosion")
	
	get_node("AnimationPlayer/AudioPlayer").position = get_global_position()
	get_node("AnimationPlayer/Sprite").position = get_global_position()

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	queue_free()
