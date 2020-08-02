extends Position2D

var PlayerPos
var GunPos
var CurrentGunNode
export var offset = Vector2(25, 10)
export var CurrentGun = "417"
var PathToGuns = "../GunPos/GunSprites/"
var AnimationSprites = {
	"417": {
		"Animation time": 1.00,
		"NodePath": str(PathToGuns) + "417"
		},
	"AWP": {
		"Animation time": 0.30,
		"NodePath": str(PathToGuns) + "AWP"
		},
	"DesertEagle": {
		"Animation time": 0.30,
		"NodePath": str(PathToGuns) + "DesertEagle"
		},
	"FAMAS": {
		"Animation time": 0.50,
		"NodePath": str(PathToGuns) + "FAMAS"
		},
	"P90": {
		"Animation time": 0.45,
		"NodePath": str(PathToGuns) + "P90"
		},
	"Six12": {
		"Animation time": 0.20,
		"NodePath": str(PathToGuns) + "Six12"
		},
}

func _process(delta: float) -> void:
	PlayerPos = get_owner().get_global_position()
	CurrentGunNode = get_node(AnimationSprites[CurrentGun]["NodePath"])
	
	look_at(get_global_mouse_position())
	CurrentGunNode.set_global_rotation(get_global_rotation()-3)
	CurrentGunNode.set_global_position(get_global_position()-offset)
	FlipSprite(get_global_rotation(), CurrentGunNode)
	
	print(get_global_rotation())

func FlipSprite(GunRotation, CurrentGunNode):
	if GunRotation > -1.5 and GunRotation < 1.5:
		CurrentGunNode.set_flip_v(true)
	else:
		CurrentGunNode.set_flip_v(false)
