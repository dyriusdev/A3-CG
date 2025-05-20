extends Node3D

func remove_wall_down() -> void:
	$"Wall Down".free()
	pass
func remove_wall_up() -> void:
	$"Wall Up".free()
	pass
func remove_wall_left() -> void:
	$"Wall Left".free()
	pass
func remove_wall_right() -> void:
	$"Wall Right".free()
	pass
