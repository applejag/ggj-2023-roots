extends RigidBody2D
class_name PulseNode

@export var initial_nodes: Array[NodePath] = []

var connected_nodes: Array[PulseNode] = []
var connecting_line_scene = preload("res://connecting_line.tscn")

func _ready() -> void:
	# Create connection for nodes specified in editor
	for node_path in initial_nodes:
		var node = get_node(node_path)
		if node != null:
			connect_node(node)

func connect_node(other: PulseNode) -> void:
	create_connection(self, other)
	push_connected_node(other)
	other.push_connected_node(self)

func push_connected_node(other: PulseNode) -> void:
	if connected_nodes == null:
		connected_nodes = []
	if not connected_nodes.has(other):
		connected_nodes.push_back(other)

func create_connection(a: PulseNode, b: PulseNode) -> void:
	var scene = connecting_line_scene.instantiate()
	var conn = scene as PulseNodeConnection
	assert(conn != null, "wrong type")
	conn.node_a = a
	conn.node_b = b
	print("assigned nodes")
	add_sibling.call_deferred(scene)
	#scene.notification(SCENE)
