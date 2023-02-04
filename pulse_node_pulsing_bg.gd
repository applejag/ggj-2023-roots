extends Sprite2D

@export var pulse_speed = 3.0
@export_range(0, 1) var min_a = 0.0
@export_range(0, 1) var max_a = 1.0
var ticks_offset = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	ticks_offset = randi()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.self_modulate.a = lerp(min_a, max_a, 0.5 + sin((Time.get_ticks_msec()+ticks_offset) * pulse_speed / 1000.0) * 0.5)
