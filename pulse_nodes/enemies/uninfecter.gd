extends NodeMove

@export var post_move_delay_min_sec = 3
@export var post_move_delay_max_sec = 5
@export var post_move_wait = 5

func _process(delta: float) -> void:
	if not next_node and host_node.uninfect():
		$AudioInfect.play()
	process_node_move(delta)
	if not next_node:
		post_move_wait -= delta
		if post_move_wait <= 0:
			var node = find_node_to_move_to()
			move_to_node(node)
			post_move_wait = randf_range(post_move_delay_min_sec, post_move_delay_max_sec)

func find_node_to_move_to() -> PulseNode:
	var infected: Array[PulseNode] = []
	for node in host_node.connected_nodes:
		if node.is_infected:
			infected.push_back(node)
	if len(infected) > 0 :
		return infected.pick_random()
	return host_node.connected_nodes.pick_random()
