extends ProgressBar

@onready var health := 100
@onready var max_health := 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func overheal(health,duration):
	pass

func player(heal):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Signal
	
	self.value = clamp(health,0,max_health)
	pass
