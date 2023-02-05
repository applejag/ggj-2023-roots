extends Node2D

@export var die_wait = 5

func _process(delta):
	die_wait -= delta
	if die_wait <= 0:
		queue_free()
