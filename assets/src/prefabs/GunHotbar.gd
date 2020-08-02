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
var CurrentGunPanelNode
var AnimationSprites
var PreviousGun = "Six12"
var SpriteNameDict = {
	0: {
		"Panel": "Panel0",
		"Image": "Image417",
		"Offset": Vector2(-15,0)
	},
	1: {
		"Panel": "Panel1",
		"Image": "ImageAWPS",
		"Offset": Vector2(-15,0)
	},
	2: {
		"Panel": "Panel2",
		"Image": "ImageFAMAS",
		"Offset": Vector2(-15,0)
	},
	3: {
		"Panel": "Panel3",
		"Image": "ImageDesertEagle",
		"Offset": Vector2(-15,0)
	},
	4: {
		"Panel": "Panel4",
		"Image": "ImageP90",
		"Offset": Vector2(-15,0)
	},
	5: {
		"Panel": "Panel5",
		"Image": "ImageSix12",
		"Offset": Vector2(0,0)
	}
}

func _process(delta: float) -> void:
	CurrentGun = get_tree().root.get_child(0).get_node("Player").get_node("GunPos").CurrentGun
	AnimationSprites = get_tree().root.get_child(0).get_node("Player").get_node("GunPos").AnimationSprites
	
	SizeCurrentGun()
	
	PreviousGun = CurrentGun
	
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
