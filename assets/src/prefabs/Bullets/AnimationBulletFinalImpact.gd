extends Node2D

func _ready():
	get_node("Animation").play("Explosion")
	
	get_node("Animation/Sprite").position = get_global_position()
	get_node("Animation/HitSound").position = get_global_position()

func _on_Animation_animation_finished(_anim_name: String) -> void:
	queue_free()
