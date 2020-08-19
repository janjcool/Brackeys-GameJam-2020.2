extends Node

var MuteMusic = false
var SoundEffects = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().root.get_child(1).paused = true
	if Input.is_action_just_released("pause"):
		get_tree().root.get_child(1).paused = false
