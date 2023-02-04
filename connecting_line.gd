extends Line2D
class_name PulseNodeConnection

@export var node_a: PulseNode
@export var node_b: PulseNode

func _ready():
	print("conn init, a & b=", node_a, node_b)
	var joint = $DampedSpringJoint2D
	joint.transform = Transform2D(node_a.position.angle_to_point(node_b.position)-deg_to_rad(90), node_a.position)
	joint.length = (node_a.position - node_b.position).length()
	joint.rest_length = joint.length - 20
	print("Length: ", joint.length, ", rest_length: ", joint.rest_length)
	joint.node_a = node_a.get_path()
	joint.node_b = node_b.get_path()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	points = [node_a.position, node_b.position]
