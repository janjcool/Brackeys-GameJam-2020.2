extends Node2D
export var CasualGamePlay0File = preload("res://assets/music/CasualMainGame.wav")
export var CasualGamePlay1File = preload("res://assets/music/CasualMainGame1.wav")
export var BossBattleFile = preload("res://assets/music/BossBattle.wav")
export var BossBattle = false
export var MuteMusic = false

var SongList = [CasualGamePlay0File, CasualGamePlay1File]
var ListIndex = 0
var MusicPlayer

func _ready() -> void:
	MusicPlayer = AudioStreamPlayer.new()
	MusicPlayer.stream = SongList[0]
	add_child(MusicPlayer)
	if MuteMusic == false:
		var DataHub = get_node("/root/DataHub")
		MuteMusic = DataHub.MuteMusic
	if MuteMusic == false:
		MusicPlayer.play()

func _process(delta: float) -> void:
	if MusicPlayer.get_playback_position() >= MusicPlayer.stream.get_length():
		MusicPlayer = AudioStreamPlayer.new()
		MusicPlayer.stream = SongList[ListIndex+1]
		add_child(MusicPlayer)
		MusicPlayer.play()
		ListIndex += 1
	
	ListIndex = -1 if ListIndex == len(SongList) else ListIndex
