extends Control

export var BackButton = "res://assets/src/Scenes/MainMenu.tscn"

func _ready() -> void:
	get_node("Menu/CenterRow/buttons/VolumeSlider/Slider").grab_focus()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		var error_code = get_tree().change_scene(BackButton)
		if error_code != 0:
			print("ERROR: ", error_code)

func _on_Slider_value_changed(value: float) -> void:
	var DataHub = get_node("/root/DataHub")
	DataHub.SoundEffects = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffects"), value)
	
func _on_BackButton_pressed() -> void:
	var error_code = get_tree().change_scene(BackButton)
	if error_code != 0:
		print("ERROR: ", error_code)


func _on_CheckBox_toggled(button_pressed: bool) -> void:
	OS.window_fullscreen = !OS.window_fullscreen


func _on_MusicSlider_value_changed(value: float) -> void:
	print(value)
	var DataHub = get_node("/root/DataHub")
	DataHub.SoundEffects = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
