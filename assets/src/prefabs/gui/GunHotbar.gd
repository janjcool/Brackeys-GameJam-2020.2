extends Control

export var ScaleCurrentGun = Vector2(1.5, 1.5)

var MagazinTextNode
var GunDict

func _process(delta: float) -> void:
	GunDict = get_tree().root.get_child(0).get_node("Player").get_node("GunPos").GunDict
	MagazinText()
	
func MagazinText():
	MagazinTextNode = get_node("MagazinText")
	var MagazinText = str(GunDict["RunTimeMagazinSize"]) + "/" + str(GunDict["MagazinSize"]) + " magazin"
	
	MagazinTextNode.set_text(MagazinText)
