extends ColorRect

func _ready() -> void:
	get_node("AnimationPlayer").play("FadeIn")
