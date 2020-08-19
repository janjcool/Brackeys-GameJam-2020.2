extends Control

export var BackButton = "res://assets/src/Scenes/MainMenu.tscn"

func _ready() -> void:
	get_node("Menu/CenterRow/buttons/BackButton").grab_focus()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		var error_code = get_tree().change_scene(BackButton)
		if error_code != 0:
			print("ERROR: ", error_code)

func _on_BackButton_pressed() -> void:
	var error_code = get_tree().change_scene(BackButton)
	if error_code != 0:
		print("ERROR: ", error_code)
