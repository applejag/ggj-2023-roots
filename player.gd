extends Node2D

@export var host_node: PulseNode
@export var next_node: PulseNode
@export_range(0, 5) var travel_time = 3.0

var next_node_t: float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var host_pos = host_node.position
	if next_node:
		next_node_t += delta / travel_time
		var next_pos = next_node.position
		if next_node_t >= 1:
			host_node = next_node
			next_node = null
			transform = Transform2D(0, next_pos)
		else:
			var pos = lerp(host_pos, next_pos, next_node_t)
			transform = Transform2D(0, pos)
	else:
		transform = Transform2D(0, host_pos)
		
func _input(event: InputEvent) -> void:
	if next_node:
		return
	if event is InputEventMouseButton and event.is_pressed():
		var point = get_global_mouse_position()
		var closest_node = get_closest_node(point)
		if closest_node:
			move_to_node(closest_node)

func move_to_node(node: PulseNode) -> void:
	next_node = node
	next_node_t = 0

func get_closest_node(point: Vector2) -> PulseNode:
	var closest_len_sqr = INF
	var closest_node: PulseNode
	for node in host_node.connected_nodes:
		# Using length_squared because it's computationally lighter
		var len_sqr = (point-node.global_position).length_squared()
		if not closest_node or len_sqr < closest_len_sqr:
			closest_len_sqr = len_sqr
			closest_node = node
	return closest_node
