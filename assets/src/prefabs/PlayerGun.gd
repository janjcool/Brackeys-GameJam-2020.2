extends Position2D

export var offset = Vector2(25, 10)
export var CurrentGun = "417"
export var BulletSpeed = 1500
export var FireRate = 1
export var TotalAmountOfGuns = 5

var PlayerPos
var GunPos
var CurrentGunNode
var PrevouiseGun = CurrentGun
var can_fire = true
var bullet = preload("res://assets/src/prefabs/bullet.tscn")
var PathToGuns = "../GunPos/GunSprites/"
var AnimationSprites = {
	"417": {
		"Animation time": 1.00,
		"NodePath": str(PathToGuns) + "417",
		"FireRate": FireRate*1.0,
		"ItemID": 0
		},
	"AWP": {
		"Animation time": 0.30,
		"NodePath": str(PathToGuns) + "AWP",
		"FireRate": FireRate*1.2,
		"ItemID": 1
		},
	"DesertEagle": {
		"Animation time": 0.30,
		"NodePath": str(PathToGuns) + "DesertEagle",
		"FireRate": FireRate*0.3,
		"ItemID": 2
		},
	"FAMAS": {
		"Animation time": 0.50,
		"NodePath": str(PathToGuns) + "FAMAS",
		"FireRate": FireRate*1.0,
		"ItemID": 3
		},
	"P90": {
		"Animation time": 0.45,
		"NodePath": str(PathToGuns) + "P90",
		"FireRate": FireRate*0.1,
		"ItemID": 4
		},
	"Six12": {
		"Animation time": 0.20,
		"NodePath": str(PathToGuns) + "Six12",
		"FireRate": FireRate*2,
		"ItemID": 5
		},
	"ItemIDList": {
		0: "417",
		1: "AWP",
		2: "DesertEagle",
		3: "FAMAS",
		4: "P90",
		5: "Six12"
	}
}

func _process(_delta: float) -> void:
	SelectGun()
	PlayerPos = get_owner().get_global_position()
	CurrentGunNode = get_node(AnimationSprites[CurrentGun]["NodePath"])
	CurrentGunNode.show()
	if not PrevouiseGun == CurrentGun:
		get_node(AnimationSprites[PrevouiseGun]["NodePath"]).hide()
	
	look_at(get_global_mouse_position())
	CurrentGunNode.set_global_rotation(get_global_rotation()-3)
	CurrentGunNode.set_global_position(get_global_position()-offset)
	FlipSprite(CurrentGunNode)
	
	if Input.is_action_pressed("fire") and can_fire:
		var bullet_instance = bullet.instance()
		bullet_instance.position = get_node("FirePoint").get_global_position()
		bullet_instance.rotation = get_global_rotation()+3
		bullet_instance.apply_impulse(Vector2(), Vector2(BulletSpeed, 0).rotated(rotation))
		get_tree().get_root().add_child(bullet_instance)
		get_node("AnimationGun").play("Shoot" + CurrentGun)
		can_fire = false
		yield(get_tree().create_timer(FireRate), "timeout")
		can_fire = true
	
	PrevouiseGun = CurrentGun

func FlipSprite(CurrentGunNode):
	if get_global_rotation() > -1.5 and get_global_rotation() < 1.5:
		CurrentGunNode.set_flip_v(true)
	else:
		CurrentGunNode.set_flip_v(false)

func SelectGun():
	if Input.is_action_just_pressed("NextEquipe") or Input.is_action_just_released("ScrollUp"):
		print("previous gun")
		var CurrentGunID = AnimationSprites[CurrentGun]["ItemID"]
		CurrentGunID = TotalAmountOfGuns if CurrentGunID == 0 else CurrentGunID-1
		CurrentGun = AnimationSprites["ItemIDList"][CurrentGunID]
	elif Input.is_action_just_pressed("PreviousEquipe") or Input.is_action_just_released("ScrollDown"):
		print("next gun")
		var CurrentGunID = AnimationSprites[CurrentGun]["ItemID"]
		CurrentGunID = 0 if CurrentGunID == TotalAmountOfGuns else CurrentGunID+1
		CurrentGun = AnimationSprites["ItemIDList"][CurrentGunID]
