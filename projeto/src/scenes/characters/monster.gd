extends CharacterBody3D

signal enemy_died

const ACCELERATION : float = 0.25

@onready var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var life_time : Timer = $LifeTime
@onready var navigation_agent : NavigationAgent3D = $NavigationAgent

@export var speed : int = 3

var player : CharacterBody3D = null

func _ready() -> void:
	life_time.start(randf_range(20, 50))
	pass

func _physics_process(delta : float) -> void:
	# Aplica a gravidade caso não esteja no chão
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if player:
		var direction : Vector3 = Vector3.ZERO
		
		navigation_agent.target_position = player.global_position
		direction = (navigation_agent.get_next_path_position() - global_position).normalized()
		
		velocity = velocity.lerp(direction * speed, ACCELERATION * delta)
		move_and_slide()
	pass

# Após o tempo de vida acabar a entidade precisa ser removida
func _on_life_time_timeout() -> void:
	enemy_died.emit()
	Globals.seeing_monster.emit(false)
	call_deferred("queue_free")
	pass


func _on_visible_on_screen_screen_entered() -> void:
	Globals.seeing_monster.emit(true)
	pass

func _on_visible_on_screen_screen_exited() -> void:
	Globals.seeing_monster.emit(false)
	pass
