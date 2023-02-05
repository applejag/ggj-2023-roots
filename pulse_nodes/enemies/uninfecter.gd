extends NodeMove
class_name Uninfecter

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

func _on_node_move_start():
	if host_node.is_connected("on_neighbor_infected_changed", self._on_neighbor_infected_changed):
		host_node.disconnect("on_neighbor_infected_changed", self._on_neighbor_infected_changed)
func _on_node_move_done():
	if not check_if_dead():
		host_node.connect("on_neighbor_infected_changed", self._on_neighbor_infected_changed)

func _on_neighbor_infected_changed(node: PulseNode):
	check_if_dead()

func check_if_dead() -> bool:
	if is_all_neighbors_infected():
		if host_node.is_connected("on_neighbor_infected_changed", self._on_neighbor_infected_changed):
			host_node.disconnect("on_neighbor_infected_changed", self._on_neighbor_infected_changed)
		queue_free()
		return true
	return false

func find_node_to_move_to() -> PulseNode:
	var infected: Array[PulseNode] = []
	for node in host_node.connected_nodes:
		if node.is_infected:
			infected.push_back(node)
	if len(infected) > 0 :
		return infected.pick_random()
	return host_node.connected_nodes.pick_random()
