extends RigidBody2D
class_name PulseNode

@export var is_root = false
@export var initial_nodes: Array[NodePath] = []
@export var force_away_from_neighbors = 20.0
@export var infected_light_color: Color = Color.PURPLE
@export var infected_bg_texture: Texture2D
@export var infected_fg_texture: Texture2D

var uninfected_light_color: Color
var uninfected_bg_texture: Texture2D
var uninfected_fg_texture: Texture2D

var is_infected = false
var connected_nodes: Array[PulseNode] = []
var connections: Array[PulseNodeConnection] = []
var connecting_line_scene = preload("res://connecting_line.tscn")

func _ready() -> void:
	# Create connection for nodes specified in editor
	for node_path in initial_nodes:
		var node = get_node(node_path)
		if node != null:
			connect_node(node)

func _process(_delta: float) -> void:
	# Add force away
	for neighbor in connected_nodes:
		for second_neighbor in neighbor.connected_nodes:
			if second_neighbor == self:
				continue
			for third_neighbor in second_neighbor.connected_nodes:
				if third_neighbor == self:
					continue
				var towards_self = position - third_neighbor.position
				var len_from_self = towards_self.length()
				var away_vector = towards_self.normalized()
				apply_central_force(away_vector * force_away_from_neighbors / sqrt(len_from_self))

func connect_node(other: PulseNode) -> void:
	var conn = create_connection(self, other)
	push_connected_node(other, conn)
	other.push_connected_node(self, conn)

func push_connected_node(other: PulseNode, conn: PulseNodeConnection) -> void:
	if not connected_nodes.has(other):
		connected_nodes.push_back(other)
	if not connections.has(conn):
		connections.push_back(conn)

func create_connection(a: PulseNode, b: PulseNode) -> PulseNodeConnection:
	var scene = connecting_line_scene.instantiate()
	var conn = scene as PulseNodeConnection
	assert(conn != null, "wrong type")
	conn.node_a = a
	conn.node_b = b
	add_sibling.call_deferred(scene)
	return scene

func infect() -> bool:
	if is_infected:
		return false
	is_infected = true
	uninfected_light_color = $Light2D.color
	uninfected_bg_texture = $Spritebg.texture
	uninfected_fg_texture = $Sprite.texture
	$Light2D.color = infected_light_color
	$Spritebg.texture = infected_bg_texture
	$Sprite.texture = infected_fg_texture
	for conn in connections:
		conn.update_infected()
	return true

func uninfect() -> bool:
	if not is_infected:
		return false
	is_infected = false
	$Light2D.color = uninfected_light_color
	$Spritebg.texture = uninfected_bg_texture
	$Sprite.texture = uninfected_fg_texture
	for conn in connections:
		conn.update_infected()
	return true
