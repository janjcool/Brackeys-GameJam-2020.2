extends Position2D

export var offset = Vector2(25, 10)
export var CurrentGun = "417"
export var BulletSpeed = 100

var PlayerPos
var GunPos
var CurrentGunNode
var bullet = preload("res://assets/src/prefabs/bullet.tscn")
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

func _process(_delta: float) -> void:
	PlayerPos = get_owner().get_global_position()
	CurrentGunNode = get_node(AnimationSprites[CurrentGun]["NodePath"])
	
	look_at(get_global_mouse_position())
	CurrentGunNode.set_global_rotation(get_global_rotation()-3)
	CurrentGunNode.set_global_position(get_global_position()-offset)
	FlipSprite(CurrentGunNode)
	
	if Input.is_action_pressed("fire"):
		var bullet_instance = bullet.instance()
		bullet_instance.position = get_global_position()
		bullet_instance.rotation_degrees = get_global_rotation()
		bullet_instance.apply_impulse(Vector2(), Vector2(BulletSpeed, 0).rotated(rotation))
		get_tree().get_root().add_child(bullet_instance)

func FlipSprite(CurrentGunNode):
	if get_global_rotation() > -1.5 and get_global_rotation() < 1.5:
		CurrentGunNode.set_flip_v(true)
	else:
		CurrentGunNode.set_flip_v(false)
