extends Node3D
@onready var animation := $"AnimationPlayer"
@onready var AnimTimer = Timer.new()

@export var Head : Node3D
@export var Sprint : Node
@export var sprint_property : String
@export_range(0.0,1.0,0.02,"Vertical Recoil") var vertical_recoil : float = 0.02
@export_range(0.0,1.0,0.02,"Chance to Shoot a Crit-Bullet") var chance_to_crit : float = 0.1
@export_range(0.0,1.0,0.02,"Horizontal Recoil") var horizontal_recoil : float = 0.02
@export var pistolSound_path : NodePath = ^"../../PistolSound"
@export var critSound_path : NodePath = ^"../../CritSound"
@export var player_path : NodePath = ^"../../"
@export var raycast_path : NodePath = ^"../../RayCast3D"

@onready var pistolSound : AudioStreamPlayer = get_node(pistolSound_path)
@onready var critSound : AudioStreamPlayer = get_node(critSound_path)
@onready var player : Node3D = get_node(player_path)
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
var Reloading : bool = false
var is_r = false

# Called when the node enters the scene tree for the first time.
func _ready():
	sprinting = Sprint.get(sprint_property)
	animation.play("Take")
	self.add_child(AnimTimer)
	AnimTimer.autostart = false
	AnimTimer.set_one_shot(true)
	await get_tree().create_timer(0.2).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	plyAnim = animation.is_playing()
	sprinting = Sprint.get(sprint_property)
	is_r = Input.is_action_just_pressed("Reload")
	if Input.is_action_just_pressed("Take or Hide Pistol"):
		if pistolOut and not plyAnim:
			pistolOut = false
			animation.play("Hide")
			print("Hiding")
			AnimTimer.start(0.4167)
			print("Time Left : " + str(AnimTimer.time_left))
		elif not pistolOut:
			pistolHide = false
			print("Taking Out")
			self.visible = true
			animation.play("Take")
			pistolOut = true
	
	if AnimTimer.time_left == 0:
		if !pistolOut and !pistolHide:
			self.visible = false
			pistolHide = true
			AnimTimer.stop()
			print("Hidden")
	elif (AnimTimer.time_left > 0):
		print("Time Left : ",AnimTimer.time_left)

	#self.rotation.x = -Head.rotation.x
	#self.rotation.y = (Head.rotation.y + deg_to_rad(180))
	#self.rotation.z = Head.rotation.z
	
	if sprinting == null:
		printerr("Sprinting not found" + str(%Sprint))
	if not plyAnim and not sprinting and sprinting == dashing:
		animation.play("Idle")
	elif not plyAnim and sprinting and sprinting == dashing:
		animation.play("Run")
	elif !Reloading and not sprinting and sprinting != dashing:
		animation.play("RunEnd")
	elif !Reloading and sprinting and sprinting != dashing:
		animation.play("RunStart")
	if (!Reloading and sprinting != dashing):
		dashing = sprinting
	if (is_r == true):
		Reloading = true
		animation.stop()
		animation.play("Reload")
	if (animation.current_animation != "Reload"):
		Reloading = false
	
	if (Input.is_action_just_pressed("Action - Fire")):
		randomize()
		randomCrit = randf_range(0,1)
		VRecoil = randf_range(0.01, vertical_recoil)
		HRecoil = randf_range(-horizontal_recoil, horizontal_recoil)
		if randomCrit < chance_to_crit:
			print("Crit Shot ", randomCrit)
			Signal(self,"PlayerShoot")
			animation.stop()
			animation.play("Shoot")
			critSound.play(0.0)
			#Head.rotate_x(HRecoil)
			Head.rot.y = Head.rot.y + HRecoil
			#Head.rotate_x(VRecoil)
			Head.rot.x = Head.rot.x + VRecoil
		else:
			print("Normal Shot ", randomCrit)
			Signal(self,"PlayerShoot")
			animation.stop()
			animation.play("Shoot")
			pistolSound.play(0.0)
			#Head.rotate_x(HRecoil)
			Head.rot.y = Head.rot.y + HRecoil
			#Head.rotate_x(VRecoil)
			Head.rot.x = Head.rot.x + VRecoil
		create_bullet_holes()

func create_bullet_holes():
	var b = bullet_hole.instantiate()
	if raycast.get_collider() and raycast.get_collider() != NPC:
		raycast.get_collider().add_child(b)
		b.global_transform.origin = raycast.get_collision_point()
		b.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)