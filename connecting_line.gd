extends Line2D


export(NodePath) var node_a
export(NodePath) var node_b

var node_a_obj: Node2D
var node_b_obj: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	node_a_obj = get_node(node_a) as Node2D
	node_b_obj = get_node(node_b) as Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	points = [node_a_obj.position, node_b_obj.position]
