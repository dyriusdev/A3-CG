extends Node3D

const DEFAULT_NORMAL = preload("res://assets/models/default_normal.png")
const DEFAULT_TILES = preload("res://assets/models/default_tiles.png")

const TILES_03 = preload("res://assets/models/tiles_03.png")
const TILES_03_NORMAL = preload("res://assets/models/tiles_03_normal.png")

const TILES_11 = preload("res://assets/models/tiles_11.png")
const TILES_11_NORMAL = preload("res://assets/models/tiles_11_normal.png")

const TILES_13 = preload("res://assets/models/tiles_13.png")
const TILES_13_NORMAL = preload("res://assets/models/tiles_13_normal.png")

func update_texture(id : int) -> void:
	for mesh in get_children():
		var material : StandardMaterial3D = mesh.get_active_material(0).duplicate()
		match id:
			0:
				material.albedo_texture = DEFAULT_TILES
				material.normal_texture = DEFAULT_NORMAL
			1:
				material.albedo_texture = TILES_03
				material.normal_texture = TILES_03_NORMAL
			2:
				material.albedo_texture = TILES_11
				material.normal_texture = TILES_11_NORMAL
			3:
				material.albedo_texture = TILES_13
				material.normal_texture = TILES_13_NORMAL
		mesh.set_surface_override_material(0, material)
	pass

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
