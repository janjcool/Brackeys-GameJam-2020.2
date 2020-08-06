extends Control

export var BackButton = "res://assets/src/Scenes/MainMenu.tscn"

func _ready() -> void:
	get_node("Menu/CenterRow/buttons/VolumeSlider/Slider").grab_focus()

func _on_Slider_value_changed(value: float) -> void:
	var DataHub = get_node("/root/DataHub")
	DataHub.SoundEffects = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffects"), value)


func _on_MuteMusic_toggled(button_pressed: bool) -> void:
	var DataHub = get_node("/root/DataHub")
	DataHub.MuteMusic = button_pressed
	
func _on_BackButton_pressed() -> void:
	get_tree().change_scene(BackButton)


func _on_CheckBox_toggled(button_pressed: bool) -> void:
	OS.window_fullscreen = !OS.window_fullscreen
