extends Node3D

@onready var fire_light : OmniLight3D = $"OmniLight3D"
@onready var audio : AudioStreamPlayer3D = $"AudioStreamPlayer3D"
@onready var audio2 : AudioStreamPlayer3D = $"AudioStreamPlayer3D2"
var relay = false


var ak_sounds = [preload("res://Audio/SFX/ak47_01.wav"),
				 preload("res://Audio/SFX/ak47_02.wav"),
				 preload("res://Audio/SFX/ak47_03.wav"),
				 preload("res://Audio/SFX/ak47_04.wav")]

func _shoot():
	fire_light.light_energy = 5
	if relay:
		audio.stop()
		audio.stream = ak_sounds.pick_random()
		audio.play()
	else:
		audio2.stop()
		audio2.stream = ak_sounds.pick_random()
		audio2.play()
	relay = not relay
	create_bullet_holes()
	await get_tree().create_timer(0.05).timeout
	fire_light.light_energy = 0

# @export var Head : Node3D
# @export var Sprint : Node
# @export var sprint_property : String
@export var raycast_path : NodePath

@onready var raycast : RayCast3D = get_node(raycast_path)

var bullet_hole = preload("res://3D/bullet_hole.tscn")

var sprinting : bool
var dashing
var plyAnim : bool = false
var pistolOut : bool = true
var pistolHide : bool = false
var randomCrit = 0.0
var HRecoil = 0.0 #Bonjour mamie
var VRecoil = 0.0

var cur_h
var cur_v

var Reloading : bool = false
var is_r = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#sprinting = Sprint.get(sprint_property)
	pass
	

func create_bullet_holes():
	var b = bullet_hole.instantiate()
	if raycast.get_collider() and raycast.get_collider() != NPC:
		raycast.get_collider().add_child(b)
		b.scale = Vector3.ONE / get_parent().scale
		b.global_transform.origin = raycast.get_collision_point()
		b.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)