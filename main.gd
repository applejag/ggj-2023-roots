extends Node2D

@export_file("*.tscn") var first_level: String = "res://levels/level01.tscn"

func _on_start_button_pressed():
	print("Loading first level: ", first_level)
	get_tree().change_scene_to_file(first_level)
