extends Node2D

var CurrentGun
var GunAndBulletDict = {
	"417": "Small",
	"AWP": "Medium",
	"DesertEagle": "Small",
	"FAMAS": "Medium",
	"P90": "Medium",
	"Six12": "Medium"
}

func _ready():
	CurrentGun = get_tree().root.get_child(0).get_node("Player").get_node("GunPos").CurrentGun
	
	get_node("AnimationBulletFinalImpact").play("Explosion" + GunAndBulletDict[CurrentGun])
	get_node("AnimationBulletFinalImpact/Sprite" + GunAndBulletDict[CurrentGun]).position = get_global_position()
	get_node("AnimationBulletFinalImpact/Hit" + GunAndBulletDict[CurrentGun]).position = get_global_position()
	get_node("AnimationBulletFinalImpact/Sprite" + GunAndBulletDict[CurrentGun]).show()


func _on_AnimationBulletFinalImpact_animation_finished(anim_name: String) -> void:
	queue_free()
