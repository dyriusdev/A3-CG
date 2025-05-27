extends CanvasLayer

@onready var members: ColorRect = $Menu/Members
@onready var world_generation: Node3D = $Background/WorldGeneration
@onready var camera_3d: Camera3D = $Background/Container/SubViewport/Camera3D

func _ready() -> void:
	get_tree().paused = false
	
	world_generation.world_ready.connect(setup)
	world_generation.generate()
	pass

func setup() -> void:
	var pos = world_generation.room_positions[0]
	camera_3d.global_position = Vector3(pos.x, 1, pos.z)
	pass

func _on_new_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/levels/game.tscn")
	pass

func _on_members_pressed() -> void:
	members.show()
	pass

func _on_back_pressed() -> void:
	members.hide()
	pass

func _on_exit_pressed() -> void:
	get_tree().quit()
	pass
