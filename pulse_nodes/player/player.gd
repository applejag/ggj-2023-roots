extends NodeMove
class_name Player

func _ready():
	host_node.infect()

func _input(event: InputEvent) -> void:
	if next_node:
		return
	if event is InputEventMouseButton and event.is_pressed():
		var point = get_global_mouse_position()
		var closest_node = get_closest_node(point)
		if closest_node:
			move_to_node(closest_node, should_reject_move(closest_node))

func _on_node_move_done(prev_node: PulseNode) -> void:
	if get_node_move_on_node(host_node):
		die()
		return

	host_node.infect()

func get_uninfected_node_count() -> int:
	var count = 0
	for sibling in get_parent().get_children():
		if sibling is PulseNode and not sibling.is_infected:
			count += 1
	return count

func should_reject_move(node: PulseNode) -> bool:
	if node.is_root and get_uninfected_node_count() > 1:
		return true
	return get_node_move_going_to_node(node) or get_node_move_on_node(node)
