extends Node3D

@export var lifetime = 0.2
@export var speed = 5
var delta_time = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position.x += speed * _delta
	delta_time += _delta
	if delta_time > lifetime:
		queue_free()
