extends Node3D

@export_node_path("AnimationPlayer") var anim_player_np
@onready var anim_player : AnimationPlayer = get_node(anim_player_np)
@onready var timer = Timer.new()
@export var time_between_shoot = 0.02
var can_shoot = true
var delta_time = 0

func _ready() -> void:
	add_child(timer)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("Action - Fire"):
		try_to_shoot()
	delta_time += _delta

func try_to_shoot():
	if delta_time > 0:
		delta_time = -time_between_shoot
		timer.start(time_between_shoot)
		anim_player.stop()
		anim_player.play("fire")