extends Control

export var LevelLoader = "res://assets/src/Scenes/LevelSelecter.tscn"
export var OptionMenu = "res://assets/src/Scenes/OptionMenu.tscn"
export var CreditMenu = "res://assets/src/Scenes/CreditScreen.tscn"

func _ready() -> void:
	get_node("Menu/CenterRow/buttons/PlayButton").grab_focus()

func _on_PlayButton_pressed() -> void:
	var error_code = get_tree().change_scene(LevelLoader)
	if error_code != 0:
		print("ERROR: ", error_code)

func _on_SettingsButton_pressed() -> void:
	var error_code = get_tree().change_scene(OptionMenu)
	if error_code != 0:
		print("ERROR: ", error_code)


func _on_ExitButton_pressed() -> void:
	get_tree().quit()


func _on_CreditButton_pressed() -> void:
	var error_code = get_tree().change_scene(CreditMenu)
	if error_code != 0:
		print("ERROR: ", error_code)
