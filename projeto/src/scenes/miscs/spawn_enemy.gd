extends Node3D

const INITIAL_DANGER_RADIUS : int = 50 

@onready var timer : Timer = $Timer

@export_node_path("CharacterBody3D") var player_path : NodePath = ""

var interval : float = 10

# Função de evento que ira criar uma instancia do inimigo
func _on_spawn_timeout() -> void:
	var mi : MeshInstance3D = MeshInstance3D.new()
	mi.mesh = SphereMesh.new()
	get_parent().add_child(mi)
	mi.global_position = get_random_position_around()
	
	timer.start(interval)
	pass

# Função que calcula uma posição aleatoria envolta do jogador
# TODO Ajustar calculo do raio
func get_random_position_around() -> Vector3:
	var rng : RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	
	var center : Vector3 = get_node(player_path).global_position
	var radius : float = INITIAL_DANGER_RADIUS - randf_range(20, 40)
	var angle : float = randf_range(0, 360)
	
	var x : float = center.x + radius * cos(angle)
	var z : float = center.z + radius * sin(angle)
	
	return Vector3(x, center.y, z)
