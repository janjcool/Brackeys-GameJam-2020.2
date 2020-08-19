extends Control

export var LevelLoader = "res://assets/src/Scenes/LevelSelecter.tscn"
export var OptionMenu = "res://assets/src/Scenes/OptionMenu.tscn"

func _ready() -> void:
	get_node("Menu/CenterRow/buttons/PlayButton").grab_focus()

func _on_PlayButton_pressed() -> void:
	get_tree().change_scene(LevelLoader)


func _on_SettingsButton_pressed() -> void:
	get_tree().change_scene(OptionMenu)


func _on_ExitButton_pressed() -> void:
	get_tree().quit()

