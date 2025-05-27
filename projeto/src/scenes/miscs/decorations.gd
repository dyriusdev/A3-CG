extends Node3D

@onready var lamp : Node3D = $"Lãmpada"
@onready var objetos : Node3D = $Objetos

func set_light() -> void:
	objetos.free()
	pass

func set_random_deco() -> void:
	lamp.free()
	return
	
	var objeto : Node3D = objetos.get_children().pick_random()
	for child in objetos.get_children():
		if child != objeto:
			child.free()
	pass
