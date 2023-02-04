extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dragging = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _integrate_forces(state):
	if dragging:
		state.transform = Transform2D(0.0, get_global_mouse_position())
	
func _input(event):
	if event is InputEventMouseButton and not event.pressed:
		dragging = false

func _on_RigidBody2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		dragging = event.pressed
