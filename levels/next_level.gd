extends Control

@export_file("*.tscn") var next_level: String

func _on_next_button_pressed():
	print("Loading next scene: ", next_level)
	get_tree().change_scene_to_file(next_level)

func _on_player_win_game():
	visible = true
	$Camera2D.enabled = true
	$Camera2D.make_current()
