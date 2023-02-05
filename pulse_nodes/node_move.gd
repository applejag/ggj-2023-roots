extends Node2D
class_name NodeMove

@export var is_infecting: bool
@export var host_node: PulseNode
@export var next_node: PulseNode
@export_range(0, 5) var travel_time = 3.0
@export var travel_curve: Curve
@export var travel_reject_curve: Curve
@export var impulse_on_arrival = 200.0
@export var impulse_on_leaving = 200.0

var next_node_t: float
var next_node_reject: bool
var death_scene = preload("res://pulse_nodes/node_move_death.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_node_move(delta)

func die():
	_on_death()
	queue_free()

func _on_death():
	var scene = death_scene.instantiate()
	scene.position = position
	var particles: GPUParticles2D = scene.find_child("InfectedParticles") if not is_infecting else scene.find_child("UninfectedParticles")
	particles.emitting = true
	scene.find_child("AudioDeath").play()
	add_sibling.call_deferred(scene)

func _on_node_move_start():
	pass
func _on_node_move_done(_prev_node: PulseNode):
	pass

func process_node_move(delta: float):
	var host_pos = host_node.position
	if next_node:
		next_node_t += delta / travel_time
		var next_pos = next_node.position
		if next_node_t >= 1:
			# Arrived.
			if next_node_reject:
				next_node = null
				transform = Transform2D(0, host_pos)
			else:
				var prev_node = host_node
				next_node.apply_central_impulse((next_pos-host_pos).normalized()*impulse_on_arrival)
				host_node = next_node
				next_node = null
				transform = Transform2D(0, next_pos)
				_on_node_move_done(prev_node)
		else:
			var t: float
			if next_node_reject:
				t = 0
				if travel_reject_curve:
					t = travel_reject_curve.sample_baked(next_node_t)
			else:
				t = next_node_t
				if travel_curve:
					t = travel_curve.sample_baked(next_node_t)
			transform = Transform2D(0, lerp(host_pos, next_pos, t))
	else:
		transform = Transform2D(0, host_pos)

func move_to_node(node: PulseNode, reject: bool = false) -> void:
	host_node.apply_central_impulse((host_node.position-node.position).normalized()*impulse_on_leaving)	
	next_node = node
	next_node_t = 0
	next_node_reject = reject
	if next_node_reject:
		$AudioMoveReject.play()
	else:
		$AudioMove.play()
		_on_node_move_start()

func get_closest_node(point: Vector2) -> PulseNode:
	if len(host_node.connected_nodes) == 0:
		return null
	if len(host_node.connected_nodes) == 1:
		return host_node.connected_nodes[0]
	var closest_len_sqr = INF
	var closest_node: PulseNode
	for node in host_node.connected_nodes:
		# Using length_squared because it's computationally lighter
		var len_sqr = (point-node.global_position).length_squared()
		if not closest_node or len_sqr < closest_len_sqr:
			closest_len_sqr = len_sqr
			closest_node = node
	return closest_node
	
func get_node_move_on_node(node: PulseNode) -> NodeMove:
	for sibling in get_parent().get_children():
		var node_move = sibling as NodeMove
		if node_move and node_move != self and node_move.host_node == node and not node_move.next_node:
			return node_move
	return null

func get_node_move_going_to_node(node: PulseNode) -> NodeMove:
	for sibling in get_parent().get_children():
		var node_move = sibling as NodeMove
		if node_move and node_move != self and node_move.next_node == node:
			return node_move
	return null

func get_connection_for_move() -> PulseNodeConnection:
	if next_node == null:
		return null
	for conn in host_node.connections:
		if conn.node_a == next_node or conn.node_b == next_node:
			return conn
	return null
