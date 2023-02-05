extends Line2D
class_name PulseNodeConnection

@export var node_a: PulseNode
@export var node_b: PulseNode
@export var infected_a_gradient: Gradient
@export var infected_b_gradient: Gradient
@export var infected_both_gradient: Gradient

func _ready() -> void:
	var joint = $DampedSpringJoint2D
	joint.transform = Transform2D(node_a.position.angle_to_point(node_b.position)-deg_to_rad(90), node_a.position)
	joint.length = (node_a.position - node_b.position).length()
	joint.rest_length = joint.length - 20
	joint.node_a = node_a.get_path()
	joint.node_b = node_b.get_path()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	points = [node_a.position, node_b.position]

func update_infected() -> void:
	if node_a.is_infected and node_b.is_infected:
		gradient = infected_both_gradient
	elif node_a.is_infected:
		gradient = infected_a_gradient
	elif node_b.is_infected:
		gradient = infected_b_gradient
	else:
		gradient = null
