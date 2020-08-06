extends Control

export var BackButton = "res://assets/src/Scenes/LevelSelecter.tscn"

onready var SceneTreeNode: = get_tree()
onready var PauseOverLay: Node2D = get_node("PauseMenu")
onready var GunDict = get_tree().root.get_child(2).get_node("Player").GunDict

var paused = false setget SetPaused

func _ready() -> void:
	get_node("PauseMenu/Menu/CenterRow/buttons/CenterPlayButton").grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.paused = not paused
		SceneTreeNode.set_input_as_handled()

func SetPaused(value: bool) -> void:
	paused = value
	SceneTreeNode.paused = value
	PauseOverLay.visible = value

func _on_CenterPlayButton_pressed() -> void:
	print("play")
	SetPaused(false)

func _on_CenterRestartButton_pressed() -> void:
	print("restart")
	SetPaused(false)
	var PlayerNode = get_tree().root.get_child(2).get_node("Player")
	PlayerNode.position = PlayerNode.StartPosition
	PlayerNode.Lives = PlayerNode.StartLives
	PlayerNode.Health = 1

func _on_CenterBackButton_pressed() -> void:
	print("back")
	SetPaused(false)
	get_tree().change_scene(BackButton)

func _process(delta: float) -> void:
	get_node("score").text = str(GunDict["RunTimeMagazinSize"]) + "/" + str(GunDict["MagazinSize"]) + " magazin \n lives: " + str(get_tree().root.get_child(2).get_node("Player").Lives)
