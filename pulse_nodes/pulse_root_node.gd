extends PulseNode

@export var spawn_uninfecters = true
@export var spawn_uninfecter_delay = 15.0
@export var spawn_uninfecter_wait = 10.0

var uninfecter_scene = preload("res://pulse_nodes/enemies/uninfecter.tscn")

func _process(delta: float) -> void:
	super(delta)
	if not is_infected and spawn_uninfecters:
		spawn_uninfecter_wait -= delta
		if spawn_uninfecter_wait <= 0:
			spawn_uninfecter_wait = spawn_uninfecter_delay
			spawn_enemy()

func spawn_enemy():
	var scene = uninfecter_scene.instantiate()
	var node_move = scene as Uninfecter
	assert(node_move != null, "wrong type")
	node_move.transform = transform
	node_move.post_move_wait = 0
	node_move.host_node = self
	add_sibling.call_deferred(scene)
