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
			post_move_wait = randf_range(post_move_delay_min_sec, post_move_delay_max_sec)
			var node = find_node_to_move_to()
			if node:
				move_to_node(node)

func _on_node_move_start():
	if not next_node.is_connected("on_neighbor_infected_changed", self._on_neighbor_infected_changed):
		next_node.connect("on_neighbor_infected_changed", self._on_neighbor_infected_changed)
	pass
func _on_node_move_done(prev_node: PulseNode):
	if prev_node.is_connected("on_neighbor_infected_changed", self._on_neighbor_infected_changed):
		prev_node.disconnect("on_neighbor_infected_changed", self._on_neighbor_infected_changed)

	var move = get_node_move_on_node(host_node)
	if move is Player:
		# KILL PLAYER!!
		move.queue_free()
	
	if not check_if_dead():
		if not host_node.is_connected("on_neighbor_infected_changed", self._on_neighbor_infected_changed):
			host_node.connect("on_neighbor_infected_changed", self._on_neighbor_infected_changed)

func _on_neighbor_infected_changed(_node: PulseNode):
	check_if_dead()

func check_if_dead() -> bool:
	if (next_node and next_node.is_all_neighbors_infected()) \
		or (not next_node and host_node.is_all_neighbors_infected()):
		if host_node.is_connected("on_neighbor_infected_changed", self._on_neighbor_infected_changed):
			host_node.disconnect("on_neighbor_infected_changed", self._on_neighbor_infected_changed)
		queue_free()
		return true
	return false

func find_node_to_move_to() -> PulseNode:
	var infected: Array[PulseNode] = []
	for node in host_node.connected_nodes:
		if node.is_infected and can_move_to_node(node):
			infected.push_back(node)
	if len(infected) > 0:
		return infected.pick_random()
	var uninhabited: Array[PulseNode] = []
	for node in host_node.connected_nodes:
		if can_move_to_node(node):
			uninhabited.push_back(node)
	if len(uninhabited) > 0:
		return uninhabited.pick_random()
	return null

func can_move_to_node(node: PulseNode) -> bool:
	if node.is_root:
		return false
	var approaching = get_node_move_going_to_node(node)
	if approaching:
		return approaching is Player
	var move = get_node_move_on_node(node)
	return not move or move is Player
