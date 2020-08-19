extends Control

export var MainMenu = "res://assets/src/Scenes/MainMenu.tscn"

func _ready() -> void:
	get_node("Menu/CenterRow/buttons/MainMenuButton").grab_focus()

func _on_ExitButton_pressed() -> void:
	get_tree().quit()

func _on_MainMenuButton_pressed() -> void:
	get_tree().change_scene(MainMenu)
