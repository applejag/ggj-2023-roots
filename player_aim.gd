extends Sprite2D

@export var angle_offset_deg = 90

func _process(_delta):
	rotation = position.angle_to_point(get_parent().get_local_mouse_position()) + deg_to_rad(angle_offset_deg)
