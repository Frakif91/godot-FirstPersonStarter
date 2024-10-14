extends Node

@onready var controller = $".."

@export_node_path("Node3D") var head_path := NodePath("../Head")
@onready var cam: Camera3D = get_node(NodePath(String(head_path) + "/Camera"))

@export var sprint_speed := 16
@export var fov_multiplier := 1.05
@onready var normal_speed: int = controller.speed
@onready var normal_fov: float = 75.0
@onready var sprinting := bool(true)

func _ready():
	print(typeof(cam))
	if (cam is Camera3D):
		normal_fov = cam.fov


# Called every physics tick. 'delta' is constant
func _physics_process(delta: float) -> void:
	if can_sprint():
		sprinting = true
		controller.speed = sprint_speed
		cam.set_fov(lerp(cam.fov, normal_fov * fov_multiplier, delta * 8))
	else:
		sprinting = false
		controller.speed = normal_speed
		cam.set_fov(lerp(cam.fov, normal_fov, delta * 8))


func can_sprint() -> bool:
	return (controller.is_on_floor() and Input.is_action_pressed(&"sprint") 
			and controller.input_axis.x >= 0.5)
