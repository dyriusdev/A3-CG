extends Node3D

const DIRECTIONS : Dictionary = {
	"up" : Vector3i.FORWARD, "down" : Vector3i.BACK,
	"left" : Vector3i.LEFT, "right" : Vector3i.RIGHT
}
const GRID : PackedScene = preload("res://src/scenes/miscs/grid.tscn")
const DECORATIONS = preload("res://src/scenes/miscs/decorations.tscn")
const CELL_SIZE : float = 0.5

@export var grid_path : NodePath = ""
@onready var grid_map : GridMap = get_node(grid_path)

func create_dungeon(texture : int) -> void:
	for c in get_children():
		remove_child(c)
		c.queue_free()
	
	for cell in grid_map.get_used_cells():
		var cell_index : int = grid_map.get_cell_item(cell)
		var cell_pos : Vector3 = Vector3(cell) + Vector3(CELL_SIZE, 0, CELL_SIZE)
		if cell_index <= 2 and cell_index >= 0:
			var dungeon_cell = GRID.instantiate()
			add_child(dungeon_cell)
			dungeon_cell.set_owner(owner)
			dungeon_cell.global_position = cell_pos
			for i in 4:
				var cell_n : Vector3i = cell + DIRECTIONS.values()[i]
				var cell_n_index : int = grid_map.get_cell_item(cell_n)
				if cell_n_index == -1 or cell_n_index == 3:
					handle_none(dungeon_cell, DIRECTIONS.keys()[i])
				else:
					var key : String = str(cell_index) + str(cell_n_index)
					call("handle_" + key, dungeon_cell, DIRECTIONS.keys()[i])
			dungeon_cell.call("update_texture", texture)
		
		if get_parent().room_positions.has(cell):
			var deco = DECORATIONS.instantiate()
			add_child(deco)
			deco.set_owner(owner)
			deco.global_position = Vector3(cell) + Vector3(CELL_SIZE, 2, CELL_SIZE)
			deco.set_light()
		
		for tiles in get_parent().room_tiles:
			randomize()
			var random : int = randi_range(1, tiles.size() / 2)
			if random < tiles.size() / 2:
				continue
			
			if tiles.has(cell):
				var deco = DECORATIONS.instantiate()
				add_child(deco)
				deco.set_owner(owner)
				deco.global_position = Vector3(cell) + Vector3(0.5, 1, 0.5)
				deco.set_random_deco()
	
	grid_map.clear()
	pass

func handle_none(_cell : Node3D, _direction : String) -> void:
	pass

func handle_00(cell : Node3D, direction : String) -> void:
	cell.call("remove_wall_" + direction)
	pass

func handle_01(cell : Node3D, direction : String) -> void:
	cell.call("remove_wall_" + direction)
	pass

func handle_02(cell : Node3D, direction : String) -> void:
	cell.call("remove_wall_" + direction)
	pass

func handle_10(cell : Node3D, direction : String) -> void:
	cell.call("remove_wall_" + direction)
	pass

func handle_11(cell : Node3D, direction : String) -> void:
	cell.call("remove_wall_" + direction)
	pass

func handle_12(cell : Node3D, direction : String) -> void:
	cell.call("remove_wall_" + direction)
	pass

func handle_20(cell : Node3D, direction : String) -> void:
	cell.call("remove_wall_" + direction)
	pass

func handle_21(cell : Node3D, direction : String) -> void:
	cell.call("remove_wall_" + direction)
	pass

func handle_22(cell : Node3D, direction : String) -> void:
	cell.call("remove_wall_" + direction)
	pass
