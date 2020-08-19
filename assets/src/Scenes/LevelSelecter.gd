extends Control

export var BackButton = "res://assets/src/Scenes/MainMenu.tscn"

export var Level1 = "res://assets/src/Levels/Level1.tscn"
export var Level2 = "res://assets/src/Levels/Level2.tscn"
export var Level3 = "res://assets/src/Levels/Level3.tscn"
export var Level4 = "res://assets/src/Levels/Level4.tscn"
export var Level5 = "res://assets/src/Levels/Level5.tscn"
export var Level6 = "res://assets/src/Levels/Level6.tscn"
export var Level7 = "res://assets/src/Levels/Level7.tscn"
export var Level8 = "res://assets/src/Levels/Level8.tscn"

func _ready() -> void:
	get_node("Menu/buttons/Level 1-4/Level1").grab_focus()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		var error_code = get_tree().change_scene(BackButton)
		if error_code != 0:
			print("ERROR: ", error_code)

func _on_BackButton_pressed() -> void:
	var error_code = get_tree().change_scene(BackButton)
	if error_code != 0:
		print("ERROR: ", error_code)

func _on_Level1_pressed() -> void:
	print("enter level")
	var error_code = get_tree().change_scene(Level1)
	if error_code != 0:
		print("ERROR: ", error_code)

func _on_Level2_pressed() -> void:
	print("enter level")
	var error_code = get_tree().change_scene(Level2)
	if error_code != 0:
		print("ERROR: ", error_code)

func _on_Level3_pressed() -> void:
	print("enter level")
	var error_code = get_tree().change_scene(Level3)
	if error_code != 0:
		print("ERROR: ", error_code)

func _on_Level4_pressed() -> void:
	print("enter level")
	var error_code = get_tree().change_scene(Level4)
	if error_code != 0:
		print("ERROR: ", error_code)

func _on_Level5_pressed() -> void:
	print("enter level")
	var error_code = get_tree().change_scene(Level5)
	if error_code != 0:
		print("ERROR: ", error_code)

func _on_Level6_pressed() -> void:
	print("enter level")
	var error_code = get_tree().change_scene(Level6)
	if error_code != 0:
		print("ERROR: ", error_code)

func _on_Level7_pressed() -> void:
	print("enter level")
	var error_code = get_tree().change_scene(Level7)
	if error_code != 0:
		print("ERROR: ", error_code)

func _on_Level8_pressed() -> void:
	print("enter level")
	var error_code = get_tree().change_scene(Level8)
	if error_code != 0:
		print("ERROR: ", error_code)
