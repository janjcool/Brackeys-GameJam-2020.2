extends Control

export var ScaleCurrentGun = Vector2(1.5, 1.5)

var PreviousGunID
var PreviousGunImageNode
var PreviousGunPanelNode
var PreviousGunImageSize
var PreviousGunPanelSize
var CurrentGun
var CurrentGunID
var CurrentGunImageNode
var MagazinTextNode
var CurrentGunPanelNode
var AnimationSprites
var TotalAmountOfGuns
var PreviousGun = "417"
var SpriteNameDict = {
	0: {
		"Panel": "Panel0",
		"Image": "Image417",
		"Offset": Vector2(-15,0),
		"QuestImage": "Image0"
	},
	1: {
		"Panel": "Panel1",
		"Image": "ImageAWPS",
		"Offset": Vector2(-15,0),
		"QuestImage": "Image1"
	},
	3: {
		"Panel": "Panel2",
		"Image": "ImageFAMAS",
		"Offset": Vector2(-15,0),
		"QuestImage": "Image3"
	},
	2: {
		"Panel": "Panel3",
		"Image": "ImageDesertEagle",
		"Offset": Vector2(-15,-10),
		"QuestImage": "Image2"
	},
	4: {
		"Panel": "Panel4",
		"Image": "ImageP90",
		"Offset": Vector2(-15,0),
		"QuestImage": "Image4"
	},
	5: {
		"Panel": "Panel5",
		"Image": "ImageSix12",
		"Offset": Vector2(-15,0),
		"QuestImage": "Image5"
	}
}

func _ready() -> void:
	TotalAmountOfGuns = get_tree().root.get_child(0).get_node("Player").get_node("GunPos").TotalAmountOfGuns
	AnimationSprites = get_tree().root.get_child(0).get_node("Player").get_node("GunPos").AnimationSprites
	CurrentGun = get_tree().root.get_child(0).get_node("Player").get_node("GunPos").CurrentGun
	
	CheckWhatGunsYouGot()
	
	CurrentGunID = AnimationSprites[CurrentGun]["ItemID"]
	CurrentGunImageNode = get_node(SpriteNameDict[CurrentGunID]["Image"])
	CurrentGunPanelNode = get_node(SpriteNameDict[CurrentGunID]["Panel"])
	
	CurrentGunImageNode.set_scale(ScaleCurrentGun)
	CurrentGunPanelNode.set_scale(ScaleCurrentGun)
	CurrentGunImageNode.set_position(CurrentGunImageNode.get_position()+SpriteNameDict[CurrentGunID]["Offset"])

func _process(delta: float) -> void:
	CurrentGun = get_tree().root.get_child(0).get_node("Player").get_node("GunPos").CurrentGun
	
	CheckIfyouNeedToCheckWhatGunsYouGot()
	MagazinText()
	SizeCurrentGun()
	
	PreviousGun = CurrentGun
	
func MagazinText():
	MagazinTextNode = get_node("MagazinText")
	var MagazinText = str(AnimationSprites[CurrentGun]["RunTimeMagazinSize"]) + "/" + str(AnimationSprites[CurrentGun]["MagazinSize"]) + " magazin"
	
	MagazinTextNode.set_text(MagazinText)

func SizeCurrentGun():
	if not PreviousGun == CurrentGun:
		CurrentGunID = AnimationSprites[CurrentGun]["ItemID"]
		CurrentGunImageNode = get_node(SpriteNameDict[CurrentGunID]["Image"])
		CurrentGunPanelNode = get_node(SpriteNameDict[CurrentGunID]["Panel"])
		
		CurrentGunImageNode.set_scale(ScaleCurrentGun)
		CurrentGunPanelNode.set_scale(ScaleCurrentGun)
		CurrentGunImageNode.set_position(CurrentGunImageNode.get_position()+SpriteNameDict[CurrentGunID]["Offset"])
		
		PreviousGunID = AnimationSprites[PreviousGun]["ItemID"]
		PreviousGunImageNode = get_node(SpriteNameDict[PreviousGunID]["Image"])
		PreviousGunPanelNode = get_node(SpriteNameDict[PreviousGunID]["Panel"])
		
		PreviousGunImageNode.set_scale(Vector2(1, 1))
		PreviousGunPanelNode.set_scale(Vector2(1, 1))
		PreviousGunImageNode.set_position(PreviousGunImageNode.get_position()-SpriteNameDict[PreviousGunID]["Offset"])

func CheckIfyouNeedToCheckWhatGunsYouGot():
	if AnimationSprites["Extra"]["GotGunChange"] == true:
		CheckWhatGunsYouGot()

func CheckWhatGunsYouGot():
	for Gun in range(0, TotalAmountOfGuns+1):
		var GunName = AnimationSprites["ItemIDList"][Gun]
		var GunNode = get_node(SpriteNameDict[Gun]["Image"])
		var PanelNode = get_node(SpriteNameDict[Gun]["Panel"])
		var QuestNode = get_node(SpriteNameDict[Gun]["QuestImage"])
		
		if AnimationSprites[GunName]["GotGun"] == true:
			GunNode.show()
			PanelNode.show()
			QuestNode.hide()
		else:
			GunNode.hide()
			PanelNode.hide()
			QuestNode.show()
