extends Node3D

const PLAYER = preload("res://src/scenes/characters/player.tscn")
const MONSTER : PackedScene = preload("res://src/scenes/characters/monster.tscn")

@onready var world_generation : Node3D = $WorldGeneration
@onready var enemy_spawn_timer : Timer = $EnemySpawnTimer

var enemy_spawned : bool = false
var player_instance : CharacterBody3D = null

func _ready() -> void:
	world_generation.world_ready.connect(setup)
	world_generation.generate()
	pass

# Pega a posição central de umas das salas do mapa
func get_random_spawn_point() -> Vector3:
	randomize()
	var positions : PackedVector3Array = world_generation.room_positions
	var index : int = randi() % positions.size()
	var point : Vector3 = positions.get(index)
	return Vector3(point.x, 1, point.z)

# Preparação do jogo e do jogador
func setup() -> void:
	player_instance = PLAYER.instantiate()
	add_child(player_instance)
	var spawn = get_random_spawn_point()
	player_instance.global_position = spawn
	pass

# Resetando limitador
func set_enemy_spawned():
	enemy_spawned = false
	pass

# Geração de inimigo
func _on_enemy_spawn_timer_timeout() -> void:
	if not enemy_spawned:
		enemy_spawned = true
		var instance = MONSTER.instantiate()
		add_child(instance)
		var spawn : Vector3 = get_random_spawn_point()
		instance.global_position = spawn
		instance.enemy_died.connect(set_enemy_spawned)
		instance.player = player_instance
	enemy_spawn_timer.start()
	pass
